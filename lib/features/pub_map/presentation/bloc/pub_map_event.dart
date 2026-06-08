part of 'pub_map_bloc.dart';

sealed class PubMapEvent extends Equatable {
  const PubMapEvent();

  @override
  List<Object?> get props => [];
}

class PubMapStarted extends PubMapEvent {
  const PubMapStarted();
}

class PubMapRegionSelected extends PubMapEvent {
  const PubMapRegionSelected(this.region);

  final PubRegion region;

  @override
  List<Object?> get props => [region];
}

class PubMapCameraIdle extends PubMapEvent {
  const PubMapCameraIdle(this.bounds);

  final MapBounds bounds;

  @override
  List<Object?> get props => [bounds];
}

class PubMapMarkerTapped extends PubMapEvent {
  const PubMapMarkerTapped(this.pubId);

  final String pubId;

  @override
  List<Object?> get props => [pubId];
}

class PubMapFilterChanged extends PubMapEvent {
  const PubMapFilterChanged(this.filter);

  final PubFilter filter;

  @override
  List<Object?> get props => [filter];
}

class PubMapSearchSubmitted extends PubMapEvent {
  const PubMapSearchSubmitted(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

class PubMapFavoriteToggled extends PubMapEvent {
  const PubMapFavoriteToggled(this.pubId);

  final String pubId;

  @override
  List<Object?> get props => [pubId];
}
