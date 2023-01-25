import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<String> getGoogleApiKey() async {
  Future<SharedPreferences> shared = SharedPreferences.getInstance();
  String googleMapsApiKey = "";
  await shared.then((sharedData) => googleMapsApiKey = sharedData.getString("google_maps_api_key")!);
  return googleMapsApiKey;
}

class LocationUtil {
  static Future<String> generateLocationPreviewImage({
    required double latitude,
    required double longitude,
  }) async {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=${await getGoogleApiKey()}';
  }

  static Future<String> getAddressFrom(LatLng position) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${await getGoogleApiKey()}';
    final response = await http.get(Uri.parse(url));
    return jsonDecode(response.body)['results'][0]['formatted_address'];
  }
}
