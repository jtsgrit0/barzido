import '../../../../core/map/map_bounds.dart';
import '../entities/pub.dart';
import '../entities/pub_filter.dart';
import '../repositories/pub_repository.dart';

class GetPubsInBounds {
  const GetPubsInBounds(this._repository);

  final PubRepository _repository;

  Future<List<Pub>> call({
    required MapBounds bounds,
    required PubFilter filter,
  }) {
    return _repository.getPubsInBounds(bounds: bounds, filter: filter);
  }
}
