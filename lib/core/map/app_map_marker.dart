import 'package:equatable/equatable.dart';

class AppMapMarker extends Equatable {
  const AppMapMarker({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.title,
    this.isSelected = false,
  });

  final String id;
  final double latitude;
  final double longitude;
  final String title;
  final bool isSelected;

  @override
  List<Object> get props => [
        id,
        latitude,
        longitude,
        title,
        isSelected,
      ];
}
