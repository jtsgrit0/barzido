import 'package:intl/intl.dart';

class Event {
  final String id;
  final String venueId;
  final String title;
  final String artist;
  final DateTime dateTime;
  final String description;
  final int price;
  final String imageUrl;
  final String genre;
  final int maxTickets;
  final int soldTickets;

  Event({
    required this.id,
    required this.venueId,
    required this.title,
    required this.artist,
    required this.dateTime,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.genre,
    required this.maxTickets,
    required this.soldTickets,
  });

  factory Event.fromMap(Map<String, dynamic> map, String id) {
    return Event(
      id: id,
      venueId: map['venueId'] ?? '',
      title: map['title'] ?? '',
      artist: map['artist'] ?? '',
      dateTime: DateTime.parse(map['dateTime']),
      description: map['description'] ?? '',
      price: map['price'] ?? 0,
      imageUrl: map['imageUrl'] ?? '',
      genre: map['genre'] ?? '',
      maxTickets: map['maxTickets'] ?? 0,
      soldTickets: map['soldTickets'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'venueId': venueId,
      'title': title,
      'artist': artist,
      'dateTime': dateTime.toIso8601String(),
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'genre': genre,
      'maxTickets': maxTickets,
      'soldTickets': soldTickets,
    };
  }

  String get formattedDate {
    return DateFormat('yyyy년 MM월 dd일 EEEE', 'ko_KR').format(dateTime);
  }

  String get formattedTime {
    return DateFormat('HH:mm', 'ko_KR').format(dateTime);
  }

  bool get isSoldOut => soldTickets >= maxTickets;
}