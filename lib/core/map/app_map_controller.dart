import 'map_bounds.dart';
import 'map_camera.dart';

abstract interface class AppMapController {
  Future<void> moveCamera(MapCamera camera);
  Future<MapBounds> getVisibleBounds();
}
