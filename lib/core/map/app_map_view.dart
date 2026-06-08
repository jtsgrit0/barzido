import 'package:flutter/widgets.dart';

import 'app_map_marker.dart';
import 'map_bounds.dart';
import 'map_camera.dart';

abstract class AppMapView extends StatelessWidget {
  const AppMapView({
    required this.camera,
    required this.markers,
    required this.onCameraIdle,
    required this.onMarkerTap,
    super.key,
  });

  final MapCamera camera;
  final List<AppMapMarker> markers;
  final ValueChanged<MapBounds> onCameraIdle;
  final ValueChanged<String> onMarkerTap;
}
