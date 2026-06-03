import 'package:google_maps_flutter/google_maps_flutter.dart';

class Venue {
  final String id;
  final String name;
  final String address;
  final String description;
  final String category; // 'pub', 'live_house'
  final LatLng location;
  final List<String> images;
  final double rating;
  final int reviewCount;
  final String region; // '홍대', '이태원', '강남' 등
  final String phoneNumber;
  final String openingHours;
  final List<String> genres; // 공연 장르

  Venue({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.category,
    required this.location,
    required this.images,
    required this.rating,
    required this.reviewCount,
    required this.region,
    required this.phoneNumber,
    required this.openingHours,
    required this.genres,
  });

  factory Venue.fromMap(Map<String, dynamic> map, String id) {
    return Venue(
      id: id,
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? 'pub',
      location: LatLng(
        map['location']['latitude'],
        map['location']['longitude'],
      ),
      images: List<String>.from(map['images'] ?? []),
      rating: map['rating']?.toDouble() ?? 0.0,
      reviewCount: map['reviewCount'] ?? 0,
      region: map['region'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      openingHours: map['openingHours'] ?? '',
      genres: List<String>.from(map['genres'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'description': description,
      'category': category,
      'location': {
        'latitude': location.latitude,
        'longitude': location.longitude,
      },
      'images': images,
      'rating': rating,
      'reviewCount': reviewCount,
      'region': region,
      'phoneNumber': phoneNumber,
      'openingHours': openingHours,
      'genres': genres,
    };
  }
}