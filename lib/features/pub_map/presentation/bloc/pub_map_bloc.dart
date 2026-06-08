import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/regions.dart';
import '../../../../core/map/map_bounds.dart';
import '../../../../core/map/map_camera.dart';
import '../../domain/entities/pub.dart';
import '../../domain/entities/pub_filter.dart';
import '../../domain/entities/pub_region.dart';
import '../../domain/usecases/get_pub_detail.dart';
import '../../domain/usecases/get_pubs_in_bounds.dart';
import '../../domain/usecases/search_pubs.dart';
import '../../domain/usecases/toggle_favorite_pub.dart';

part 'pub_map_event.dart';
part 'pub_map_state.dart';

class PubMapBloc extends Bloc<PubMapEvent, PubMapState> {
  PubMapBloc({
    required GetPubsInBounds getPubsInBounds,
    required GetPubDetail getPubDetail,
    required SearchPubs searchPubs,
    required ToggleFavoritePub toggleFavoritePub,
  })  : _getPubsInBounds = getPubsInBounds,
        _getPubDetail = getPubDetail,
        _searchPubs = searchPubs,
        _toggleFavoritePub = toggleFavoritePub,
        super(PubMapState.initial()) {
    on<PubMapStarted>(_onStarted);
    on<PubMapRegionSelected>(_onRegionSelected);
    on<PubMapCameraIdle>(_onCameraIdle);
    on<PubMapMarkerTapped>(_onMarkerTapped);
    on<PubMapFilterChanged>(_onFilterChanged);
    on<PubMapSearchSubmitted>(_onSearchSubmitted);
    on<PubMapFavoriteToggled>(_onFavoriteToggled);
  }

  final GetPubsInBounds _getPubsInBounds;
  final GetPubDetail _getPubDetail;
  final SearchPubs _searchPubs;
  final ToggleFavoritePub _toggleFavoritePub;

  Future<void> _onStarted(
    PubMapStarted event,
    Emitter<PubMapState> emit,
  ) async {
    await _loadBounds(state.bounds, emit);
  }

  Future<void> _onRegionSelected(
    PubMapRegionSelected event,
    Emitter<PubMapState> emit,
  ) async {
    final preset = presetFor(event.region);
    final filter = state.filter.copyWith(region: event.region);

    emit(
      state.copyWith(
        selectedRegion: event.region,
        camera: preset.camera,
        bounds: preset.bounds,
        filter: filter,
        query: '',
        clearSelectedPub: true,
      ),
    );
    await _loadBounds(preset.bounds, emit, filter: filter);
  }

  Future<void> _onCameraIdle(
    PubMapCameraIdle event,
    Emitter<PubMapState> emit,
  ) async {
    emit(state.copyWith(bounds: event.bounds));
    await _loadBounds(event.bounds, emit);
  }

  Future<void> _onMarkerTapped(
    PubMapMarkerTapped event,
    Emitter<PubMapState> emit,
  ) async {
    final pub = await _getPubDetail(event.pubId);
    emit(state.copyWith(selectedPub: pub));
  }

  Future<void> _onFilterChanged(
    PubMapFilterChanged event,
    Emitter<PubMapState> emit,
  ) async {
    emit(state.copyWith(filter: event.filter, clearSelectedPub: true));
    await _loadBounds(state.bounds, emit, filter: event.filter);
  }

  Future<void> _onSearchSubmitted(
    PubMapSearchSubmitted event,
    Emitter<PubMapState> emit,
  ) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      await _loadBounds(state.bounds, emit);
      return;
    }

    emit(state.copyWith(isLoading: true, query: query, clearSelectedPub: true));
    final results = await _searchPubs(query: query, filter: state.filter);
    emit(state.copyWith(isLoading: false, visiblePubs: results, query: query));
  }

  Future<void> _onFavoriteToggled(
    PubMapFavoriteToggled event,
    Emitter<PubMapState> emit,
  ) async {
    final updated = await _toggleFavoritePub(event.pubId);
    final visiblePubs = state.visiblePubs
        .map((pub) => pub.id == updated.id ? updated : pub)
        .toList();
    emit(
      state.copyWith(
        visiblePubs: visiblePubs,
        selectedPub: state.selectedPub?.id == updated.id ? updated : null,
      ),
    );
  }

  Future<void> _loadBounds(
    MapBounds bounds,
    Emitter<PubMapState> emit, {
    PubFilter? filter,
  }) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final pubs = await _getPubsInBounds(
        bounds: bounds,
        filter: filter ?? state.filter,
      );
      emit(state.copyWith(isLoading: false, visiblePubs: pubs));
    } on Object catch (error) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: '펍 정보를 불러오지 못했습니다: $error',
        ),
      );
    }
  }
}
