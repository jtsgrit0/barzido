import '../entities/pub.dart';
import '../repositories/pub_repository.dart';

class GetPubDetail {
  const GetPubDetail(this._repository);

  final PubRepository _repository;

  Future<Pub> call(String pubId) {
    return _repository.getPubDetail(pubId);
  }
}
