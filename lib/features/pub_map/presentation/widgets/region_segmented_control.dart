import 'package:flutter/material.dart';

import '../../domain/entities/pub_region.dart';

class RegionSegmentedControl extends StatelessWidget {
  const RegionSegmentedControl({
    required this.selectedRegion,
    required this.onChanged,
    super.key,
  });

  final PubRegion selectedRegion;
  final ValueChanged<PubRegion> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<PubRegion>(
      segments: PubRegion.values
          .map(
            (region) => ButtonSegment(
              value: region,
              label: Text(region.label),
              icon: const Icon(Icons.location_on_outlined),
            ),
          )
          .toList(),
      selected: {selectedRegion},
      onSelectionChanged: (selection) => onChanged(selection.single),
    );
  }
}
