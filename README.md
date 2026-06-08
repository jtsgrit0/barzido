# Clzido

서울 이태원과 홍대 중심의 펍 지도 Flutter 앱입니다.

## Current Scaffold

- Clean Architecture 기반 `features/pub_map`
- `flutter_bloc` 상태 관리
- `get_it` 의존성 주입
- 네이버 지도 SDK 연결 전 mock 지도 UI
- 홍대/이태원 샘플 펍 데이터
- macOS 13 리팩토링 구조 문서: `MACOS13_REFACTOR_ARCHITECTURE.md`
- 라이브바/공연장 seed 데이터 출처: `DATA_SOURCES.md`

## Setup

현재 환경에 Flutter CLI가 없어 플랫폼 폴더는 생성하지 못했습니다.
Flutter 설치 후 프로젝트 루트에서 아래 명령을 실행하세요.

```powershell
flutter create .
flutter pub get
flutter run
```

네이버 지도 SDK를 실제로 연결할 때는 `lib/core/map`에 adapter를 추가하고
`flutter_naver_map` 초기화를 `lib/main.dart` 또는 bootstrap 단계에 넣으면 됩니다.

## macOS 13 Refactor

macOS 13 desktop에서는 네이버 지도 SDK를 직접 붙이기보다 `core/map` adapter를 통해 mock map, web map, mobile naver map을 분리하는 구조를 권장합니다.
자세한 내용은 `MACOS13_REFACTOR_ARCHITECTURE.md`를 확인하세요.
