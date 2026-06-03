import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barzido/main.dart';
import 'package:barzido/models/venue.dart';
import 'package:barzido/models/event.dart';

void main() {
  testWidgets('앱이 정상적으로 실행되고 홈화면이 렌더링된다', (WidgetTester tester) async {
    // 앱 빌드
    await tester.pumpWidget(const MyApp());

    // 앱 바 제목이 존재하는지 확인
    expect(find.text('BARZIDO'), findsOneWidget);
    
    // 검색창이 존재하는지 확인
    expect(find.byType(TextField), findsOneWidget);
  });

  test('Venue 모델이 정상적으로 직렬화/역직렬화된다', () {
    // 테스트용 맵 데이터
    final venueMap = {
      'name': '테스트 펍',
      'address': '서울시 마포구 홍대입구',
      'latitude': 37.5568,
      'longitude': 126.9242,
      'category': 'pub',
      'region': '홍대',
      'genres': ['록', '인디'],
      'rating': 4.5,
      'imageUrl': 'https://example.com/image.jpg',
      'description': '테스트 설명',
    };

    // fromMap으로 Venue 객체 생성
    final venue = Venue.fromMap(venueMap, 'test-id');
    
    // 필드값이 정상적으로 설정되었는지 확인
    expect(venue.name, '테스트 펍');
    expect(venue.region, '홍대');
    expect(venue.category, 'pub');
    expect(venue.id, 'test-id');
    
    // toMap으로 다시 맵으로 변환 테스트
    final convertedMap = venue.toMap();
    expect(convertedMap['name'], '테스트 펍');
  });

  test('Event 모델이 정상적으로 생성된다', () {
    // 테스트용 Event 생성
    final event = Event(
      id: 'event-1',
      venueId: 'venue-1',
      name: '테스트 공연',
      date: DateTime.now(),
      startTime: '20:00',
      price: 20000,
      description: '테스트 공연 설명',
      imageUrl: 'https://example.com/event.jpg',
    );

    expect(event.name, '테스트 공연');
    expect(event.price, 20000);
    expect(event.venueId, 'venue-1');
  });
}