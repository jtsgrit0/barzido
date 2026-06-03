# BARZIDO 🍻

서울 홍대, 이태원을 시작으로 전국의 펍과 라이브 공연장을 소개하는 Flutter 앱

## ✨ 주요 기능

- 🗺️ **지도에서 보기**: 구글 지도에서 주변 모든 공연장/펍 확인
- 📍 **지역 필터**: 홍대, 이태원, 강남, 건대, 신촌 등 지역별 필터링
- 🎵 **라이브 이벤트**: 다가오는 공연 일정 확인
- 🔍 **검색 기능**: 장소명, 주소, 공연 장르로 검색
- 🎭 **카테고리 분류**: 펍/라이브 공연장 구분

## 🛠 기술 스택

- **Flutter** (Dart)
- **Firebase** (Firestore)
- **Google Maps Flutter**
- **Provider** (상태관리)
- 기타 패키지: cached_network_image, flutter_rating_bar, url_launcher 등

## 🚀 시작하기

### 필수 설정

1. Firebase 프로젝트 생성
   - `firebase_core`, `cloud_firestore` 사용을 위한 설정
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist` 추가

2. Google Maps API 키 발급
   - Android: `android/app/src/main/AndroidManifest.xml`에 추가
   - iOS: `ios/Runner/Info.plist`에 추가

### 설치 및 실행

```bash
flutter pub get
flutter run
```

## 📱 앱 스크린 구조

- **HomeScreen**: 메인 화면, 다가오는 공연 + 장소 리스트
- **MapScreen**: 지도에서 모든 장소 확인
- **VenueDetailScreen**: 개별 장소 상세 정보 + 예정된 공연

## 📸 스크린샷 (개발중)

추후 추가 예정

## 📄 라이선스

MIT License