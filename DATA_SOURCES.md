# Venue Data Sources

Last researched: 2026-06-04

이 파일은 앱의 초기 seed 데이터에 반영한 홍대/이태원 라이브바 및 공연장 출처입니다.

실시간 영업 여부, 공연 일정, 입장료, 예약 가능 여부는 자주 바뀌므로 앱 데이터에는 확정값으로 넣지 않았습니다. 현재 `openingStatus`는 대부분 `unknown`으로 두고, 이후 공식 API 또는 운영자 검수 데이터로 갱신하는 것을 권장합니다.

## Hongdae

### Club FF

- Type: live music club
- Address used: 서울 마포구 서교동 407-8
- Coordinates used: `37.550275, 126.922303`
- Sources:
  - My Guide Seoul: https://www.myguideseoul.com/nightlife/club-ff
  - 10 Magazine directory: https://10mag.com/directory/nightlife/live-music-bars/seoul/club-ff-mapo-gu-seoul/

### Rolling Hall

- Type: live music venue / concert hall
- Address used: 서울 마포구 어울마당로 35
- Coordinates used: approximate, `37.5497, 126.9219`
- Sources:
  - VisitKorea: https://english.visitkorea.or.kr/svc/whereToGo/locIntrdn/rgnContentsView.do?vcontsId=84134
  - Time Out Seoul: https://www.timeout.com/seoul/music/rolling-hall

### KT&G Sangsangmadang Live Hall

- Type: culture complex / live hall
- Address used: 서울 마포구 어울마당로 65
- Coordinates used: approximate, `37.5509, 126.9210`
- Sources:
  - Visit Seoul: https://english.visitseoul.net/MapoArea/KT-G-Sangsang-Madang-en/ENP024561
  - VisitKorea Design Square listing: https://english.visitkorea.or.kr/svc/whereToGo/locIntrdn/rgnContentsView.do?vcontsId=86751

### Jebi Dabang

- Type: cafe, bar, cultural live space
- Address used: 서울 마포구 와우산로 24
- Coordinates used: approximate, `37.5479, 126.9228`
- Sources:
  - CTR: https://en.ctrplus.com/jebi
  - Trazy: https://www.trazy.com/ko/spot/908/jebi-dabang-%EC%A0%9C%EB%B9%84%EB%8B%A4%EB%B0%A9-nightlife-bar

### Strange Fruit

- Type: small indie live venue
- Address used: 서울 마포구 서교동 330-15
- Coordinates used: `37.556177, 126.926671`
- Sources:
  - My Guide Seoul event listing: https://www.myguideseoul.com/events/live-music-at-strange-fruit
  - Wanderlog listing: https://wanderlog.com/place/details/3996488/strange-fruit

### Cafe Unplugged

- Type: live cafe / acoustic venue
- Address used: 서울 마포구 와우산로33길 26
- Coordinates used: approximate, `37.5562, 126.9290`
- Source:
  - K-DJ listing: https://k-dj.jp/index.php?club=cafe-unplugged&lang=en&show=clubs

## Itaewon / HBC

### All That Jazz

- Type: jazz live bar
- Address used: 서울 용산구 이태원로 216, 2층
- Coordinates used: approximate, `37.5349, 126.9972`
- Sources:
  - Official site: https://allthatjazz.kr/info/aboutmenu
  - Visit Seoul: https://english.visitseoul.net/restaurants/All%20That%20Jazz/ENP001154

### Boogie Woogie

- Type: live music bar
- Address used: 서울 용산구 이태원동 281-6
- Coordinates used: approximate, `37.5350, 126.9941`
- Source:
  - Trazy: https://www.trazy.com/spot/3162/boogie-woogie-nightlife-bar

### The Studio HBC

- Type: live music / performance bar
- Address used: 서울 용산구 용산동2가 39-16 B1
- Coordinates used: approximate, `37.5412, 126.9875`
- Source:
  - Official site: https://camaratamusic.wixsite.com/website

### Southside Parlor

- Type: cocktail bar / live music venue
- Address used: 서울 용산구 보광로60길 36-5
- Coordinates used: approximate, `37.5328, 126.9947`
- Source:
  - TableJourney: https://tablejourney.com/south-korea/seoul/bars/southside-parlor-itaewon/

### Planet Hustle

- Type: nightlife group / bar / music events
- Address used: 서울 용산구 이태원동 34-65, 1층
- Coordinates used: approximate, `37.5332, 126.9915`
- Source:
  - Official site: https://www.planethustle.com/

### Pet Sounds

- Type: rock bar / live music bar
- Address used: 서울 용산구 이태원동 278-8, 3층
- Coordinates used: `37.539192, 126.989004`
- Sources:
  - My Guide Seoul: https://www.myguideseoul.com/nightlife/pet-sounds
  - Corner: https://www.corner.inc/place/578088
  - Trazy: https://www.trazy.com/spot/3163/pet-sounds-nightlife-bar

## Data Quality Notes

- Review counts are set to `0` because current seed data does not use a review-provider API.
- Ratings are placeholder editorial weights for UI sorting experiments, not scraped review scores.
- Approximate coordinates should be replaced with geocoded coordinates from Naver/Kakao/Google Maps API before production.
- Performance schedules should be fetched from official venue sites, ticketing platforms, or curated admin data rather than inferred from generic web listings.
