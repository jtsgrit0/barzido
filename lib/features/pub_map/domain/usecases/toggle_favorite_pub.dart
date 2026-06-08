import '../entities/pub.dart';
import '../repositories/pub_repository.dart';

class ToggleFavoritePub {
  const ToggleFavoritePub(this._repository);

  final PubRepository _repository;

  Future<Pub> call(String pubId) {
    return _repository.toggleFavorite(pubId);
  }
}
