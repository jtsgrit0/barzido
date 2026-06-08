import '../../../../core/map/map_bounds.dart';
import '../entities/pub.dart';
import '../entities/pub_filter.dart';

abstract interface class PubRepository {
  Future<List<Pub>> getPubsInBounds({
    required MapBounds bounds,
    required PubFilter filter,
  });

  Future<Pub> getPubDetail(String pubId);

  Future<List<Pub>> searchPubs({
    required String query,
    required PubFilter filter,
  });

  Future<Pub> toggleFavorite(String pubId);
}
