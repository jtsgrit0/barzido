import '../entities/pub.dart';
import '../entities/pub_filter.dart';
import '../repositories/pub_repository.dart';

class SearchPubs {
  const SearchPubs(this._repository);

  final PubRepository _repository;

  Future<List<Pub>> call({
    required String query,
    required PubFilter filter,
  }) {
    return _repository.searchPubs(query: query, filter: filter);
  }
}
