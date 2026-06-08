import '../map/map_bounds.dart';
import '../map/map_camera.dart';
import '../../features/pub_map/domain/entities/pub_region.dart';

class RegionPreset {
  const RegionPreset({
    required this.region,
    required this.label,
    required this.camera,
    required this.bounds,
  });

  final PubRegion region;
  final String label;
  final MapCamera camera;
  final MapBounds bounds;
}

const hongdaePreset = RegionPreset(
  region: PubRegion.hongdae,
  label: 'Hongdae',
  camera: MapCamera(latitude: 37.5563, longitude: 126.9236, zoom: 15),
  bounds: MapBounds(
    southWestLat: 37.545,
    southWestLng: 126.91,
    northEastLat: 37.565,
    northEastLng: 126.936,
  ),
);

const itaewonPreset = RegionPreset(
  region: PubRegion.itaewon,
  label: 'Itaewon',
  camera: MapCamera(latitude: 37.5345, longitude: 126.9946, zoom: 15),
  bounds: MapBounds(
    southWestLat: 37.525,
    southWestLng: 126.982,
    northEastLat: 37.544,
    northEastLng: 127.006,
  ),
);

const regionPresets = [hongdaePreset, itaewonPreset];

RegionPreset presetFor(PubRegion region) {
  return regionPresets.firstWhere((preset) => preset.region == region);
}
