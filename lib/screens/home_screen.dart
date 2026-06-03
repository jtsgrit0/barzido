import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../providers/venue_provider.dart';
import '../widgets/venue_card.dart';
import '../widgets/event_card.dart';
import '../widgets/filter_chip_widget.dart';
import 'venue_detail_screen.dart';
import 'map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BARZIDO',
          style: TextStyle(
            color: Color(0xFFE91E63),
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.map, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MapScreen()),
              );
            },
            tooltip: '지도에서 보기',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<VenueProvider>().fetchAllVenues(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 검색창
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: '펍, 공연장, 장르 검색...',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: const Color(0xFF1E1E1E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                  onChanged: (value) {
                    context.read<VenueProvider>().updateSearchQuery(value);
                  },
                ),
              ),

              // 다가오는 공연 섹션
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  '🔥 다가오는 공연',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Consumer<VenueProvider>(
                builder: (context, provider, child) {
                  if (provider.upcomingEvents.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        '현재 예정된 공연이 없습니다',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                  return SizedBox(
                    height: 260,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: provider.upcomingEvents.length,
                      itemBuilder: (context, index) {
                        final event = provider.upcomingEvents[index];
                        return EventCard(
                          event: event,
                          onTap: () {
                            // 이벤트 상세 화면으로 이동
                          },
                        );
                      },
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // 필터 섹션
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '지역 필터',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Consumer<VenueProvider>(
                      builder: (context, provider, child) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: provider.availableRegions.map((region) {
                              return FilterChipWidget(
                                label: region,
                                isSelected: provider.selectedRegions.contains(region),
                                onTap: () => provider.toggleRegion(region),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '카테고리 필터',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Consumer<VenueProvider>(
                      builder: (context, provider, child) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              FilterChipWidget(
                                label: '전체',
                                isSelected: provider.selectedCategories.isEmpty,
                                onTap: () {
                                  // 전체 선택시 모든 카테고리 해제
                                  for (var cat in provider.selectedCategories) {
                                    provider.toggleCategory(cat);
                                  }
                                },
                              ),
                              ...provider.availableCategories.map((category) {
                                return FilterChipWidget(
                                  label: category == 'live_house' ? '라이브 공연장' : '펍',
                                  isSelected: provider.selectedCategories.contains(category),
                                  onTap: () => provider.toggleCategory(category),
                                );
                              }),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 장소 목록
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '주변 장소',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Consumer<VenueProvider>(
                      builder: (context, provider, child) {
                        return Text(
                          '${provider.venues.length}곳',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Consumer<VenueProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (provider.venues.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Text(
                          '조건에 맞는 장소가 없습니다',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.venues.length,
                    itemBuilder: (context, index) {
                      final venue = provider.venues[index];
                      return VenueCard(
                        venue: venue,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VenueDetailScreen(venue: venue),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}