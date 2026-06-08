import 'package:equatable/equatable.dart';

class MapBounds extends Equatable {
  const MapBounds({
    required this.southWestLat,
    required this.southWestLng,
    required this.northEastLat,
    required this.northEastLng,
  });

  final double southWestLat;
  final double southWestLng;
  final double northEastLat;
  final double northEastLng;

  bool contains({required double latitude, required double longitude}) {
    return latitude >= southWestLat &&
        latitude <= northEastLat &&
        longitude >= southWestLng &&
        longitude <= northEastLng;
  }

  @override
  List<Object> get props => [
        southWestLat,
        southWestLng,
        northEastLat,
        northEastLng,
      ];
}
