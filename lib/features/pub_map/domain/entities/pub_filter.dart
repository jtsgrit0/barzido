import 'package:equatable/equatable.dart';

import 'pub_region.dart';

class PubFilter extends Equatable {
  const PubFilter({
    this.region,
    this.openNowOnly = false,
    this.tags = const {},
    this.minRating,
  });

  final PubRegion? region;
  final bool openNowOnly;
  final Set<String> tags;
  final double? minRating;

  PubFilter copyWith({
    PubRegion? region,
    bool? openNowOnly,
    Set<String>? tags,
    double? minRating,
  }) {
    return PubFilter(
      region: region ?? this.region,
      openNowOnly: openNowOnly ?? this.openNowOnly,
      tags: tags ?? this.tags,
      minRating: minRating ?? this.minRating,
    );
  }

  @override
  List<Object?> get props => [region, openNowOnly, tags, minRating];
}
