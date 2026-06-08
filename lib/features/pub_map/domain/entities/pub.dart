import 'package:equatable/equatable.dart';

import 'opening_status.dart';
import 'pub_region.dart';

class Pub extends Equatable {
  const Pub({
    required this.id,
    required this.name,
    required this.region,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.tags,
    required this.rating,
    required this.reviewCount,
    required this.openingStatus,
    this.isFavorite = false,
  });

  final String id;
  final String name;
  final PubRegion region;
  final double latitude;
  final double longitude;
  final String address;
  final List<String> tags;
  final double rating;
  final int reviewCount;
  final OpeningStatus openingStatus;
  final bool isFavorite;

  Pub copyWith({bool? isFavorite}) {
    return Pub(
      id: id,
      name: name,
      region: region,
      latitude: latitude,
      longitude: longitude,
      address: address,
      tags: tags,
      rating: rating,
      reviewCount: reviewCount,
      openingStatus: openingStatus,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object> get props => [
        id,
        name,
        region,
        latitude,
        longitude,
        address,
        tags,
        rating,
        reviewCount,
        openingStatus,
        isFavorite,
      ];
}
