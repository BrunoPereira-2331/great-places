import 'dart:io';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class Place {
  final String id;
  final String? title;
  final PlaceLocation? location;
  final File? image;

  const Place({
    required this.id,
    this.title,
    this.location,
    this.image,
  });
}

class PlaceLocation {
  final double latitude;
  final double longitude;
  final String? address;

  LatLng toLatLgn() {
    return LatLng(latitude, longitude);
  }

  const PlaceLocation({
    required this.latitude,
    required this.longitude,
    this.address,
  });
}
