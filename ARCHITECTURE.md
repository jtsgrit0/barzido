# Seoul Pub Map Flutter Architecture

서울 이태원과 홍대 중심의 펍 지도 앱을 위한 Flutter 아키텍처 설계입니다.

## Product Scope

- 이태원, 홍대 지역 중심의 펍 지도 탐색
- 지도 마커, 현재 위치, 지역 빠른 이동
- 펍 검색, 필터, 상세 정보
- 즐겨찾기와 최근 본 펍 저장
- 서버/API 연동 전까지 로컬 JSON 또는 로컬 DB 기반 개발 가능

## Recommended Stack

- App: Flutter
- Map: `flutter_naver_map`
- State: `flutter_bloc`
- DI: `get_it` + `injectable` 또는 단순 수동 DI
- Location: `geolocator`
- Local cache: `isar` 또는 `hive`
- Network: `dio`
- Model serialization: `freezed` + `json_serializable`

국내 지도 정확도와 POI 맥락을 고려하면 1차 지도 SDK는 네이버 지도를 추천합니다. 추후 글로벌 확장이 필요하면 지도 어댑터를 둬서 Google Maps로 교체 가능하게 설계합니다.

## Directory Structure

```text
lib/
  main.dart
  app/
    app.dart
    router.dart
    di.dart
  core/
    constants/
      regions.dart
    error/
      app_exception.dart
      failure.dart
    location/
      location_service.dart
    map/
      map_camera.dart
      map_marker_cache.dart
      map_sdk_adapter.dart
    network/
      dio_client.dart
    theme/
      app_theme.dart
    utils/
      debounce.dart
  features/
    pub_map/
      data/
        datasources/
          pub_local_data_source.dart
          pub_remote_data_source.dart
        models/
          pub_model.dart
          pub_marker_model.dart
        repositories/
          pub_repository_impl.dart
      domain/
        entities/
          pub.dart
          pub_filter.dart
          pub_region.dart
        repositories/
          pub_repository.dart
        usecases/
          get_pubs_in_bounds.dart
          get_pub_detail.dart
          search_pubs.dart
          toggle_favorite_pub.dart
      presentation/
        bloc/
          pub_map_bloc.dart
          pub_map_event.dart
          pub_map_state.dart
        pages/
          pub_map_page.dart
          pub_detail_page.dart
        widgets/
          region_segmented_control.dart
          pub_bottom_sheet.dart
          pub_filter_sheet.dart
          pub_marker_layer.dart
    favorites/
      data/
      domain/
      presentation/
```

## Architecture

```text
Presentation
  Page, Widget, Bloc
      ↓ events / states
Domain
  Entity, Repository interface, UseCase
      ↓ abstract contract
Data
  Repository implementation, Remote source, Local source, DTO
      ↓
External
  Naver Map SDK, Location API, Backend API, Local DB
```

의존성 방향은 항상 바깥에서 안쪽으로 향합니다.

- `presentation`은 `domain`만 알고, API 응답 모델을 직접 다루지 않습니다.
- `domain`은 Flutter SDK, 지도 SDK, DB 패키지에 의존하지 않는 순수 Dart 영역입니다.
- `data`는 API/DB/SDK 세부 구현을 감싸고, 도메인 엔티티로 변환합니다.

## Domain Model

```dart
class Pub {
  final String id;
  final String name;
  final PubRegion region;
  final double latitude;
  final double longitude;
  final String address;
  final List<String> tags;
  final double rating;
  final int reviewCount;
  final bool isFavorite;
  final OpeningStatus openingStatus;
}
```

```dart
enum PubRegion {
  hongdae,
  itaewon,
}
```

```dart
class PubFilter {
  final PubRegion? region;
  final bool openNowOnly;
  final Set<String> tags;
  final double? minRating;
}
```

## Main Use Cases

- `GetPubsInBounds`
  - 현재 지도 화면의 `southWest`, `northEast`, `filter`를 받아 화면 안의 펍만 조회합니다.
- `SearchPubs`
  - 이름, 태그, 주소 기준 검색을 수행합니다.
- `GetPubDetail`
  - 마커 또는 리스트 항목 선택 시 상세 데이터를 조회합니다.
- `ToggleFavoritePub`
  - 즐겨찾기 상태를 로컬 DB에 저장하고 지도/상세 화면에 반영합니다.

## Bloc Design

### Events

```dart
sealed class PubMapEvent {}

class PubMapStarted extends PubMapEvent {}
class PubMapRegionSelected extends PubMapEvent {
  final PubRegion region;
}
class PubMapCameraIdle extends PubMapEvent {
  final MapBounds bounds;
}
class PubMapMarkerTapped extends PubMapEvent {
  final String pubId;
}
class PubMapFilterChanged extends PubMapEvent {
  final PubFilter filter;
}
class PubMapSearchSubmitted extends PubMapEvent {
  final String query;
}
```

### State

```dart
class PubMapState {
  final bool isLoading;
  final PubRegion selectedRegion;
  final MapCamera camera;
  final List<Pub> visiblePubs;
  final Pub? selectedPub;
  final PubFilter filter;
  final String? errorMessage;
}
```

상태 클래스를 하나로 유지하면 지도 화면처럼 상태 조합이 많은 UI에서 로딩, 마커, 선택된 카드, 필터 상태를 안정적으로 관리하기 쉽습니다.

## Map Strategy

### Region Presets

```dart
const hongdaeCamera = MapCamera(
  latitude: 37.5563,
  longitude: 126.9236,
  zoom: 15,
);

const itaewonCamera = MapCamera(
  latitude: 37.5345,
  longitude: 126.9946,
  zoom: 15,
);
```

상단에는 `홍대`, `이태원` 세그먼트 컨트롤을 두고 선택 시 카메라를 이동합니다.

### Bounds Query

마커는 전체 펍을 한 번에 렌더링하지 않고 현재 지도 화면 기준으로 가져옵니다.

```text
onCameraIdle
  -> 현재 LatLngBounds 추출
  -> PubMapCameraIdle(bounds)
  -> GetPubsInBounds(bounds, filter)
  -> visiblePubs 갱신
```

지도 이동 중에는 API를 호출하지 않고, `cameraIdle` 시점에만 debounce 후 호출합니다.

### Marker Optimization

- 커스텀 마커 이미지는 앱 시작 또는 첫 지도 진입 시 캐싱합니다.
- 같은 카테고리/상태의 마커는 같은 `BitmapDescriptor`를 재사용합니다.
- 마커가 많아지면 클러스터링 계층을 별도 서비스로 분리합니다.

## Data Flow

```text
User taps Hongdae
  -> PubMapRegionSelected(hongdae)
  -> Bloc updates camera target
  -> UI animates map camera
  -> onCameraIdle emits bounds
  -> GetPubsInBounds
  -> Repository checks cache
  -> Remote fetch if needed
  -> Bloc emits visible pubs
  -> UI renders markers
```

## API Shape

초기 백엔드 API는 아래 정도면 충분합니다.

```http
GET /pubs?swLat=37.0&swLng=126.0&neLat=37.9&neLng=127.1&region=hongdae&openNow=true
GET /pubs/{pubId}
GET /pubs/search?q=cocktail&region=itaewon
```

응답 DTO는 `data/models`에 두고, 화면에서는 반드시 `domain/entities/Pub`으로 변환해서 사용합니다.

## Local Cache

로컬 저장 대상:

- 즐겨찾기 펍 ID
- 최근 본 펍 ID
- 마지막 선택 지역
- 최근 지도 카메라 위치
- 마지막으로 받은 bounds별 펍 캐시

캐시 키 예시:

```text
pubs:{region}:{rounded-sw-lat}:{rounded-sw-lng}:{rounded-ne-lat}:{rounded-ne-lng}:{filter-hash}
```

## UI Composition

`PubMapPage` 구성:

- 전체 화면 지도
- 상단 지역 세그먼트 컨트롤
- 상단 검색 버튼 또는 검색 입력
- 우측 현재 위치 버튼
- 하단 필터 바
- 마커 선택 시 `PubBottomSheet`

앱 첫 화면은 랜딩 페이지가 아니라 바로 지도여야 합니다.

## Implementation Order

1. Flutter 프로젝트 생성 및 기본 라우터/테마/DI 구성
2. `pub_map` 도메인 엔티티와 repository interface 작성
3. 임시 로컬 JSON data source로 홍대/이태원 샘플 펍 연결
4. `PubMapBloc`과 지도 화면 연결
5. 네이버 지도 SDK, 현재 위치 권한, 지역 이동 구현
6. 마커 선택 bottom sheet와 상세 화면 구현
7. 필터, 검색, 즐겨찾기 추가
8. 실제 API 연동 및 캐시 전략 적용

## Test Strategy

- UseCase 단위 테스트
- Repository cache/remote fallback 테스트
- Bloc event/state 테스트
- 지도 SDK 의존 부분은 adapter로 감싸고 mock 테스트
- 주요 UI는 widget test로 필터 변경, 마커 선택, region 전환 확인

## Notes

지도 SDK는 앱 전체에 직접 퍼뜨리지 말고 `core/map`의 adapter 뒤에 숨깁니다. 이렇게 하면 네이버 지도에서 Google Maps 또는 Kakao Map으로 바꿔야 할 때 presentation 계층의 수정 범위를 크게 줄일 수 있습니다.
