# macOS 13 Refactor Architecture

이 문서는 `clzido`를 macOS 13 환경에서 리팩토링하고, 이후 Flutter Web/iOS/Android/macOS desktop으로 확장하기 위한 구조 가이드입니다.

## Goal

- macOS 13 개발 환경에서 안정적으로 리팩토링한다.
- 지도 SDK, 위치 권한, 플랫폼 UI 차이를 앱 핵심 로직에서 분리한다.
- `flutter_naver_map`처럼 특정 플랫폼에 묶인 패키지가 전체 앱 구조를 막지 않게 한다.
- 처음에는 mock/map preview로 빠르게 개발하고, 나중에 실제 지도 구현체를 교체한다.

## Important Constraint

현재 `flutter_naver_map`은 pub.dev 설명 기준 Android/iOS용 네이버 지도 플러그인입니다. 따라서 macOS desktop 앱에서는 지도 구현을 직접 붙이는 대신 adapter 구조를 먼저 만들어야 합니다.

```text
Presentation
  PubMapPage
      ↓
Map Facade
  AppMapView
      ↓
Platform Implementations
  MobileNaverMapView      Android / iOS
  WebMapView              Web
  DesktopMockMapView      macOS 13 desktop
```

## Target Architecture

```text
lib/
  app/
    app.dart
    di.dart
    router.dart
  core/
    platform/
      app_platform.dart
      platform_capabilities.dart
    map/
      app_map_controller.dart
      app_map_marker.dart
      app_map_view.dart
      map_bounds.dart
      map_camera.dart
      implementations/
        desktop_mock_map_view.dart
        mobile_naver_map_view.dart
        web_map_view.dart
    location/
      app_location_service.dart
      geolocator_location_service.dart
      mock_location_service.dart
  features/
    pub_map/
      data/
      domain/
      presentation/
```

## Refactor Rule

`features/pub_map`는 지도 SDK를 직접 import하지 않습니다.

허용:

```dart
import 'package:clzido/core/map/app_map_view.dart';
import 'package:clzido/core/map/map_bounds.dart';
import 'package:clzido/core/map/map_camera.dart';
```

금지:

```dart
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
```

지도 SDK import는 `core/map/implementations/*` 안에서만 허용합니다.

## Map Abstraction

### AppMapView

```dart
class AppMapView extends StatelessWidget {
  const AppMapView({
    required this.camera,
    required this.markers,
    required this.onCameraIdle,
    required this.onMarkerTap,
    super.key,
  });

  final MapCamera camera;
  final List<AppMapMarker> markers;
  final ValueChanged<MapBounds> onCameraIdle;
  final ValueChanged<String> onMarkerTap;
}
```

### AppMapMarker

```dart
class AppMapMarker {
  const AppMapMarker({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.title,
    this.isSelected = false,
  });

  final String id;
  final double latitude;
  final double longitude;
  final String title;
  final bool isSelected;
}
```

## Platform Capability Matrix

| Feature | Android | iOS | Web | macOS 13 desktop |
| --- | --- | --- | --- | --- |
| Naver native map | Yes | Yes | No | No |
| Current location | Yes | Yes | Browser permission | macOS permission |
| Pub search/filter | Yes | Yes | Yes | Yes |
| Favorites/cache | Yes | Yes | Yes | Yes |
| Mock map fallback | Optional | Optional | Useful | Required |

## macOS 13 Development Strategy

1. macOS 13에서는 `DesktopMockMapView`로 지도 UI/상태/검색/필터를 리팩토링한다.
2. 지도 좌표 계산과 bounds query는 mock view에서도 동일하게 이벤트를 발생시킨다.
3. 모바일 빌드에서는 `MobileNaverMapView`가 같은 interface를 구현한다.
4. 지도 SDK 교체가 필요하면 `core/map/implementations`만 수정한다.

## Dependency Rules

### Domain

- Flutter import 금지
- 지도 SDK import 금지
- DB/API 패키지 import 금지

### Data

- API, DB, DTO 변환 담당
- 지도 렌더링 관련 코드 금지

### Presentation

- Bloc과 widget 담당
- 지도는 `AppMapView`만 사용
- 플랫폼 분기 직접 작성 금지

### Core Map

- 플랫폼별 지도 SDK 격리
- marker descriptor 캐시
- camera/bounds 변환

## Platform Selection

```dart
AppMapImplementation resolveMapImplementation(AppPlatform platform) {
  return switch (platform) {
    AppPlatform.android || AppPlatform.ios => AppMapImplementation.naver,
    AppPlatform.web => AppMapImplementation.web,
    AppPlatform.macos => AppMapImplementation.desktopMock,
    _ => AppMapImplementation.desktopMock,
  };
}
```

macOS 13 리팩토링 중에는 `desktopMock`을 기본값으로 두는 것이 안전합니다.

## Suggested Refactor Order

1. `PubMarkerLayer`를 `DesktopMockMapView`로 이름과 책임을 바꾼다.
2. `AppMapView`, `AppMapMarker`, `AppMapController` interface를 만든다.
3. `PubMapPage`가 `PubMarkerLayer` 대신 `AppMapView`를 사용하게 한다.
4. `flutter_naver_map` 직접 사용 코드는 `MobileNaverMapView`에만 둔다.
5. `LocationService`를 interface로 분리하고 macOS에서는 mock/current-permission 구현을 선택한다.
6. `Bloc` 테스트는 지도 SDK 없이 유지한다.
7. 실제 macOS build가 필요하면 `flutter create --platforms=macos .` 후 macOS deployment target을 13으로 맞춘다.

## macOS 13 Project Notes

Flutter 공식 macOS 배포 문서는 Xcode의 `Deployment Target` 설정을 안내합니다. macOS 13을 명확히 지원 대상으로 둘 경우, 생성된 `macos/Runner.xcworkspace`에서 deployment target을 13으로 통일하세요.

```text
macos/
  Runner.xcworkspace
  Runner/
    DebugProfile.entitlements
    Release.entitlements
```

위치 권한을 실제로 사용할 때는 macOS entitlement와 `Info.plist` 설명 문구를 함께 확인해야 합니다. 개발 초기에는 현재 위치 기능을 mock으로 두고, 지도 리팩토링이 끝난 뒤 권한 처리를 붙이는 편이 좋습니다.

## Testing

macOS 13 리팩토링에서 우선순위가 높은 테스트:

- `GetPubsInBounds`가 지역/bounds/filter를 정확히 적용하는지
- `PubMapBloc`이 지역 전환 시 camera/bounds/filter를 함께 바꾸는지
- `AppMapView` mock 구현이 marker tap과 camera idle callback을 발생시키는지
- 즐겨찾기 토글 후 리스트와 bottom sheet 상태가 함께 갱신되는지

## Do Not Couple

아래 결합은 피합니다.

- `PubMapBloc`이 Naver map controller를 직접 보관
- `Pub` entity에 SDK 전용 marker 객체 포함
- UI widget에서 API DTO 직접 사용
- macOS 조건문이 feature widget 곳곳에 흩어짐

## End State

최종적으로 `PubMapPage`는 플랫폼을 몰라도 됩니다.

```text
PubMapPage
  -> PubMapBloc
  -> AppMapView
      -> desktop mock on macOS 13
      -> naver native map on Android/iOS
      -> web map on browser
```

이 구조면 macOS 13에서 리팩토링과 UI 검증을 계속 진행하면서도, 실제 배포 플랫폼별 지도 SDK 선택을 뒤로 미룰 수 있습니다.
