import 'package:google_maps_webservice/places.dart';

class GooglePlacesService {
  final GoogleMapsPlaces _places;
  final String _apiKey;

  GooglePlacesService(String apiKey)
      : _places = GoogleMapsPlaces(apiKey: apiKey),
        _apiKey = apiKey;

  Future<PlacesDetailsResponse> getPlaceDetails(String placeId) async {
    final response = await _places.getDetailsByPlaceId(placeId);
    if (response.isOk) {
      return response;
    } else {
      throw Exception('Failed to load place details: ${response.errorMessage}');
    }
  }

  String getPhotoUrl(String photoReference, {int maxWidth = 400}) {
    return 'https://maps.googleapis.com/maps/api/place/photo'
        '?maxwidth=$maxWidth'
        '&photoreference=$photoReference'
        '&key=$_apiKey';
  }
}