import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/venue.dart';
import '../models/event.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 모든 공연장/펍 가져오기
  Future<List<Venue>> getAllVenues() async {
    QuerySnapshot snapshot = await _db.collection('venues').get();
    return snapshot.docs.map((doc) => Venue.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }

  // 지역별 공연장/펍 가져오기 (홍대, 이태원 등)
  Future<List<Venue>> getVenuesByRegion(String region) async {
    QuerySnapshot snapshot = await _db.collection('venues').where('region', isEqualTo: region).get();
    return snapshot.docs.map((doc) => Venue.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }

  // 카테고리별 필터링 (펍, 라이브하우스)
  Future<List<Venue>> getVenuesByCategory(String category) async {
    QuerySnapshot snapshot = await _db.collection('venues').where('category', isEqualTo: category).get();
    return snapshot.docs.map((doc) => Venue.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }

  // 특정 공연장 상세 정보 가져오기
  Future<Venue?> getVenueById(String venueId) async {
    DocumentSnapshot doc = await _db.collection('venues').doc(venueId).get();
    if (doc.exists) {
      return Venue.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  // 다가오는 공연 이벤트 가져오기
  Future<List<Event>> getUpcomingEvents() async {
    final now = DateTime.now();
    QuerySnapshot snapshot = await _db
        .collection('events')
        .where('dateTime', isGreaterThan: Timestamp.fromDate(now))
        .orderBy('dateTime')
        .limit(20)
        .get();
    return snapshot.docs.map((doc) => Event.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }

  // 특정 공연장의 이벤트 가져오기
  Future<List<Event>> getEventsByVenueId(String venueId) async {
    final now = DateTime.now();
    QuerySnapshot snapshot = await _db
        .collection('events')
        .where('venueId', isEqualTo: venueId)
        .where('dateTime', isGreaterThan: Timestamp.fromDate(now))
        .orderBy('dateTime')
        .get();
    return snapshot.docs.map((doc) => Event.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }

  // 장르별 이벤트 필터링
  Future<List<Event>> getEventsByGenre(String genre) async {
    final now = DateTime.now();
    QuerySnapshot snapshot = await _db
        .collection('events')
        .where('genre', isEqualTo: genre)
        .where('dateTime', isGreaterThan: Timestamp.fromDate(now))
        .orderBy('dateTime')
        .get();
    return snapshot.docs.map((doc) => Event.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }

  // 샘플 데이터 추가 함수 (초기 데이터 세팅용)
  Future<void> addSampleVenues() async {
    // 홍대 지역 샘플 데이터
    final hongdaeVenues = [
      {
        'name': '클럽 사운드웨이브',
        'address': '서울 마포구 홍대입구',
        'description': '홍대 대표 라이브 클럽, 매주 다양한 장르의 밴드 공연이 열리는 곳',
        'category': 'live_house',
        'location': {'latitude': 37.5570, 'longitude': 126.9240},
        'images': ['https://example.com/image1.jpg'],
        'rating': 4.5,
        'reviewCount': 328,
        'region': '홍대',
        'phoneNumber': '02-333-4444',
        'openingHours': '18:00 - 06:00',
        'genres': ['록', '인디', '메탈'],
      },
      {
        'name': '벨벳 펍',
        'address': '서울 마포구 홍대입구',
        'description': '아늬한 분위기의 수제 맥주 펍, 주말에 어쿠스틱 라이브 공연이 열림',
        'category': 'pub',
        'location': {'latitude': 37.5565, 'longitude': 126.9235},
        'images': ['https://example.com/image2.jpg'],
        'rating': 4.3,
        'reviewCount': 215,
        'region': '홍대',
        'phoneNumber': '02-555-6666',
        'openingHours': '17:00 - 02:00',
        'genres': ['어쿠스틱', '재즈'],
      },
    ];

    // 이태원 지역 샘플 데이터
    final itaewonVenues = [
      {
        'name': '이태원 재즈클럽',
        'address': '서울 용산구 이태원동',
        'description': '매일 밤 라이브 재즈 공연이 펼쳐지는 이태원 명소',
        'category': 'live_house',
        'location': {'latitude': 37.5345, 'longitude': 126.9920},
        'images': ['https://example.com/image3.jpg'],
        'rating': 4.7,
        'reviewCount': 452,
        'region': '이태원',
        'phoneNumber': '02-777-8888',
        'openingHours': '19:00 - 04:00',
        'genres': ['재즈', '소울'],
      },
      {
        'name': '락앤롤 바',
        'address': '서울 용산구 이태원동',
        'description': '클래식 록이 흐르는 감성적인 펍, 주말 라이브 공연 개최',
        'category': 'pub',
        'location': {'latitude': 37.5350, 'longitude': 126.9930},
        'images': ['https://example.com/image4.jpg'],
        'rating': 4.2,
        'reviewCount': 178,
        'region': '이태원',
        'phoneNumber': '02-999-0000',
        'openingHours': '18:00 - 03:00',
        'genres': ['록', '블루스'],
      },
    ];

    // 샘플 데이터 Firestore에 추가
    for (var venue in [...hongdaeVenues, ...itaewonVenues]) {
      await _db.collection('venues').add(venue);
    }
  }
}