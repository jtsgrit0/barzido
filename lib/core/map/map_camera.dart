import 'package:equatable/equatable.dart';

class MapCamera extends Equatable {
  const MapCamera({
    required this.latitude,
    required this.longitude,
    required this.zoom,
  });

  final double latitude;
  final double longitude;
  final double zoom;

  @override
  List<Object> get props => [latitude, longitude, zoom];
}
