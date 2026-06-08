import '../../../../core/map/map_bounds.dart';
import '../../domain/entities/opening_status.dart';
import '../../domain/entities/pub.dart';
import '../../domain/entities/pub_filter.dart';
import '../../domain/repositories/pub_repository.dart';
import '../datasources/pub_local_data_source.dart';

class PubRepositoryImpl implements PubRepository {
  const PubRepositoryImpl({required PubLocalDataSource localDataSource})
      : _localDataSource = localDataSource;

  final PubLocalDataSource _localDataSource;

  @override
  Future<List<Pub>> getPubsInBounds({
    required MapBounds bounds,
    required PubFilter filter,
  }) async {
    final pubs = await _allPubs();
    return pubs.where((pub) {
      return bounds.contains(
            latitude: pub.latitude,
            longitude: pub.longitude,
          ) &&
          _matchesFilter(pub, filter);
    }).toList();
  }

  @override
  Future<Pub> getPubDetail(String pubId) async {
    return (await _allPubs()).firstWhere((pub) => pub.id == pubId);
  }

  @override
  Future<List<Pub>> searchPubs({
    required String query,
    required PubFilter filter,
  }) async {
    final normalizedQuery = query.trim().toLowerCase();
    final pubs = await _allPubs();

    return pubs.where((pub) {
      final haystack = [
        pub.name,
        pub.address,
        ...pub.tags,
        pub.region.name,
      ].join(' ').toLowerCase();

      return haystack.contains(normalizedQuery) && _matchesFilter(pub, filter);
    }).toList();
  }

  @override
  Future<Pub> toggleFavorite(String pubId) async {
    final favorites = await _localDataSource.getFavoriteIds();
    if (favorites.contains(pubId)) {
      favorites.remove(pubId);
    } else {
      favorites.add(pubId);
    }
    await _localDataSource.saveFavoriteIds(favorites);
    return getPubDetail(pubId);
  }

  Future<List<Pub>> _allPubs() async {
    final favoriteIds = await _localDataSource.getFavoriteIds();
    final models = await _localDataSource.getPubs();
    return models
        .map((model) => model.toEntity(isFavorite: favoriteIds.contains(model.id)))
        .toList();
  }

  bool _matchesFilter(Pub pub, PubFilter filter) {
    if (filter.region != null && pub.region != filter.region) {
      return false;
    }
    if (filter.openNowOnly && pub.openingStatus != OpeningStatus.open) {
      return false;
    }
    if (filter.minRating != null && pub.rating < filter.minRating!) {
      return false;
    }
    if (filter.tags.isNotEmpty &&
        !filter.tags.every((tag) => pub.tags.contains(tag))) {
      return false;
    }
    return true;
  }
}
