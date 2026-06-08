part of 'pub_map_bloc.dart';

class PubMapState extends Equatable {
  const PubMapState({
    required this.selectedRegion,
    required this.camera,
    required this.bounds,
    this.isLoading = false,
    this.visiblePubs = const [],
    this.selectedPub,
    this.filter = const PubFilter(),
    this.query = '',
    this.errorMessage,
  });

  factory PubMapState.initial() {
    return const PubMapState(
      selectedRegion: PubRegion.hongdae,
      camera: hongdaePreset.camera,
      bounds: hongdaePreset.bounds,
      filter: PubFilter(region: PubRegion.hongdae),
    );
  }

  final bool isLoading;
  final PubRegion selectedRegion;
  final MapCamera camera;
  final MapBounds bounds;
  final List<Pub> visiblePubs;
  final Pub? selectedPub;
  final PubFilter filter;
  final String query;
  final String? errorMessage;

  PubMapState copyWith({
    bool? isLoading,
    PubRegion? selectedRegion,
    MapCamera? camera,
    MapBounds? bounds,
    List<Pub>? visiblePubs,
    Pub? selectedPub,
    bool clearSelectedPub = false,
    PubFilter? filter,
    String? query,
    String? errorMessage,
  }) {
    return PubMapState(
      isLoading: isLoading ?? this.isLoading,
      selectedRegion: selectedRegion ?? this.selectedRegion,
      camera: camera ?? this.camera,
      bounds: bounds ?? this.bounds,
      visiblePubs: visiblePubs ?? this.visiblePubs,
      selectedPub: clearSelectedPub ? null : selectedPub ?? this.selectedPub,
      filter: filter ?? this.filter,
      query: query ?? this.query,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        selectedRegion,
        camera,
        bounds,
        visiblePubs,
        selectedPub,
        filter,
        query,
        errorMessage,
      ];
}
