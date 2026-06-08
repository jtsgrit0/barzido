import 'package:get_it/get_it.dart';

import '../features/pub_map/data/datasources/pub_local_data_source.dart';
import '../features/pub_map/data/repositories/pub_repository_impl.dart';
import '../features/pub_map/domain/repositories/pub_repository.dart';
import '../features/pub_map/domain/usecases/get_pub_detail.dart';
import '../features/pub_map/domain/usecases/get_pubs_in_bounds.dart';
import '../features/pub_map/domain/usecases/search_pubs.dart';
import '../features/pub_map/domain/usecases/toggle_favorite_pub.dart';
import '../features/pub_map/presentation/bloc/pub_map_bloc.dart';

final sl = GetIt.instance;

void configureDependencies() {
  if (sl.isRegistered<PubMapBloc>()) {
    return;
  }

  sl
    ..registerLazySingleton<PubLocalDataSource>(SamplePubLocalDataSource.new)
    ..registerLazySingleton<PubRepository>(
      () => PubRepositoryImpl(localDataSource: sl()),
    )
    ..registerLazySingleton(() => GetPubsInBounds(sl()))
    ..registerLazySingleton(() => GetPubDetail(sl()))
    ..registerLazySingleton(() => SearchPubs(sl()))
    ..registerLazySingleton(() => ToggleFavoritePub(sl()))
    ..registerFactory(
      () => PubMapBloc(
        getPubsInBounds: sl(),
        getPubDetail: sl(),
        searchPubs: sl(),
        toggleFavoritePub: sl(),
      ),
    );
}
