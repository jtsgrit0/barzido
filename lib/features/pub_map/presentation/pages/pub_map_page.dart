import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../app/di.dart';
import '../../../../app/router.dart';
import '../../../../core/constants/regions.dart';
import '../../../../core/map/map_bounds.dart' as core;
import '../../domain/entities/pub_region.dart';
import '../bloc/pub_map_bloc.dart';
import '../widgets/pub_bottom_sheet.dart';
import '../widgets/region_segmented_control.dart';

class PubMapPage extends StatelessWidget {
  const PubMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PubMapBloc>()..add(const PubMapStarted()),
      child: const _PubMapView(),
    );
  }
}

class _PubMapView extends StatefulWidget {
  const _PubMapView();

  @override
  State<_PubMapView> createState() => _PubMapViewState();
}

class _PubMapViewState extends State<_PubMapView> {
  final _searchController = TextEditingController();
  GoogleMapController? _mapController;

  @override
  void dispose() {
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<PubMapBloc, PubMapState>(
          listener: (context, state) {
            if (_mapController != null && state.camera != null) {
              _mapController!.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(state.camera!.latitude, state.camera!.longitude),
                    zoom: state.camera!.zoom,
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Positioned.fill(
                  child: GoogleMap(
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        state.camera?.latitude ?? presetFor(state.selectedRegion).camera.latitude,
                        state.camera?.longitude ?? presetFor(state.selectedRegion).camera.longitude,
                      ),
                      zoom: state.camera?.zoom ?? presetFor(state.selectedRegion).camera.zoom,
                    ),
                    onCameraIdle: () async {
                      if (_mapController == null) return;
                      final bounds = await _mapController!.getVisibleRegion();
                      context.read<PubMapBloc>().add(
                            PubMapCameraIdle(
                              core.MapBounds(
                                southWest: core.MapLatLng(
                                  bounds.southwest.latitude,
                                  bounds.southwest.longitude,
                                ),
                                northEast: core.MapLatLng(
                                  bounds.northeast.latitude,
                                  bounds.northeast.longitude,
                                ),
                              ),
                            ),
                          );
                    },
                    markers: state.visiblePubs.map((pub) {
                      return Marker(
                        markerId: MarkerId(pub.id),
                        position: LatLng(pub.latitude, pub.longitude),
                        onTap: () {
                          context.read<PubMapBloc>().add(PubMapMarkerTapped(pub.id));
                        },
                        // TODO: Add custom marker icon
                      );
                    }).toSet(),
                    myLocationButtonEnabled: false,
                    myLocationEnabled: true,
                    zoomControlsEnabled: false,
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 16,
                  right: 16,
                  child: Column(
                    children: [
                      _SearchField(controller: _searchController),
                      const SizedBox(height: 10),
                      RegionSegmentedControl(
                        selectedRegion: state.selectedRegion,
                        onChanged: (region) {
                          context.read<PubMapBloc>().add(
                                PubMapRegionSelected(region),
                              );
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 16,
                  bottom: state.selectedPub == null ? 24 : 152,
                  child: Column(
                    children: [
                      FloatingActionButton.small(
                        heroTag: 'open-now',
                        tooltip: '영업 중',
                        onPressed: () {
                          final filter = state.filter.copyWith(
                            openNowOnly: !state.filter.openNowOnly,
                          );
                          context.read<PubMapBloc>().add(
                                PubMapFilterChanged(filter),
                              );
                        },
                        child: Icon(
                          state.filter.openNowOnly
                              ? Icons.schedule
                              : Icons.schedule_outlined,
                        ),
                      ),
                      const SizedBox(height: 8),
                      FloatingActionButton.small(
                        heroTag: 'reset-region',
                        tooltip: state.selectedRegion.label,
                        onPressed: () {
                          context.read<PubMapBloc>().add(
                                PubMapRegionSelected(state.selectedRegion),
                              );
                        },
                        child: const Icon(Icons.my_location),
                      ),
                    ],
                  ),
                ),
                if (state.isLoading)
                  const Positioned(
                    left: 16,
                    right: 16,
                    bottom: 24,
                    child: LinearProgressIndicator(),
                  ),
                if (state.errorMessage != null)
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 24,
                    child: Material(
                      color: Theme.of(context).colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(state.errorMessage!),
                      ),
                    ),
                  ),
                if (state.selectedPub != null)
                  Positioned(
                    left: 12,
                    right: 12,
                    bottom: 12,
                    child: PubBottomSheet(
                      pub: state.selectedPub!,
                      onFavoriteTap: () {
                        context.read<PubMapBloc>().add(
                              PubMapFavoriteToggled(state.selectedPub!.id),
                            );
                      },
                      onDetailTap: () {
                        Navigator.of(context).pushNamed(
                          AppRouter.pubDetail,
                          arguments: state.selectedPub!.id,
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(8),
      child: TextField(
        controller: controller,
        textInputAction: TextInputAction.search,
        onSubmitted: (query) {
          context.read<PubMapBloc>().add(PubMapSearchSubmitted(query));
        },
        decoration: InputDecoration(
          hintText: '펍 이름, 분위기, 태그 검색',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            tooltip: '검색',
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              context.read<PubMapBloc>().add(
                    PubMapSearchSubmitted(controller.text),
                  );
            },
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}