import '../../domain/entities/opening_status.dart';
import '../../domain/entities/pub.dart';
import '../../domain/entities/pub_region.dart';

class PubModel {
  const PubModel({
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

  Pub toEntity({bool isFavorite = false}) {
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
      isFavorite: isFavorite,
    );
  }
}
