import 'package:flutter/foundation.dart';
import '../models/venue.dart';
import '../models/event.dart';
import '../services/firestore_service.dart';

class VenueProvider with ChangeNotifier {
  final FirestoreService _service = FirestoreService();
  
  List<Venue> _venues = [];
  List<Venue> _filteredVenues = [];
  List<Event> _upcomingEvents = [];
  List<String> _selectedRegions = ['홍대', '이태원'];
  List<String> _selectedCategories = [];
  String _searchQuery = '';
  
  List<Venue> get venues => _filteredVenues;
  List<Event> get upcomingEvents => _upcomingEvents;
  List<String> get selectedRegions => _selectedRegions;
  List<String> get selectedCategories => _selectedCategories;
  List<String> get availableRegions => ['홍대', '이태원', '강남', '건대', '신촌'];
  List<String> get availableCategories => ['pub', 'live_house'];
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  VenueProvider() {
    fetchAllVenues();
    fetchUpcomingEvents();
  }

  Future<void> fetchAllVenues() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _venues = await _service.getAllVenues();
      _applyFilters();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching venues: $e');
      }
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchUpcomingEvents() async {
    try {
      _upcomingEvents = await _service.getUpcomingEvents();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching events: $e');
      }
    }
  }

  void toggleRegion(String region) {
    if (_selectedRegions.contains(region)) {
      _selectedRegions.remove(region);
    } else {
      _selectedRegions.add(region);
    }
    _applyFilters();
    notifyListeners();
  }

  void toggleCategory(String category) {
    if (_selectedCategories.contains(category)) {
      _selectedCategories.remove(category);
    } else {
      _selectedCategories.add(category);
    }
    _applyFilters();
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredVenues = _venues.where((venue) {
      // 지역 필터
      final regionMatch = _selectedRegions.isEmpty || _selectedRegions.contains(venue.region);
      
      // 카테고리 필터
      final categoryMatch = _selectedCategories.isEmpty || _selectedCategories.contains(venue.category);
      
      // 검색어 필터
      final searchMatch = _searchQuery.isEmpty || 
          venue.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          venue.address.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          venue.genres.any((g) => g.toLowerCase().contains(_searchQuery.toLowerCase()));
      
      return regionMatch && categoryMatch && searchMatch;
    }).toList();
  }

  Future<Venue?> getVenueById(String id) async {
    return await _service.getVenueById(id);
  }

  Future<List<Event>> getEventsForVenue(String venueId) async {
    return await _service.getEventsByVenueId(venueId);
  }
}