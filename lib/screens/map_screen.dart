import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/venue_provider.dart';
import '../models/venue.dart';
import 'venue_detail_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;
  final Set<Marker> _markers = {};

  // 서울 중심 좌표
  static const CameraPosition _seoulCenter = CameraPosition(
    target: LatLng(37.5665, 126.9780),
    zoom: 13,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadVenues();
    });
  }

  void _loadVenues() {
    final provider = context.read<VenueProvider>();
    _createMarkers(provider.venues);
  }

  void _createMarkers(List<Venue> venues) {
    setState(() {
      _markers.clear();
      for (final venue in venues) {
        final marker = Marker(
          markerId: MarkerId(venue.id),
          position: venue.location,
          infoWindow: InfoWindow(
            title: venue.name,
            snippet: venue.region,
            onTap: () {
              // 마커 클릭시 상세 화면으로 이동
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VenueDetailScreen(venue: venue),
                ),
              );
            },
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            venue.category == 'live_house' 
                ? BitmapDescriptor.hueRose 
                : BitmapDescriptor.hueCyan,
          ),
        );
        _markers.add(marker);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 장소 목록이 변경될 때마다 마커 업데이트
    final provider = context.watch<VenueProvider>();
    _createMarkers(provider.venues);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('지도에서 보기'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _seoulCenter,
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapToolbarEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },
          ),
          // 범례
          Positioned(
            bottom: 32,
            left: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.pink,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '라이브 공연장',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.cyan,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '펍',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // 현재 위치로 이동 버튼
          Positioned(
            bottom: 32,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                _controller?.animateCamera(
                  CameraUpdate.newCameraPosition(_seoulCenter),
                );
              },
              backgroundColor: const Color(0xFFE91E63),
              child: const Icon(Icons.my_location, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}