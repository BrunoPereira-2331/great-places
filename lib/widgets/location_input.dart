import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/screens/map_screen.dart';
import 'package:great_places/utils/location_util.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({Key? key, required this.onSelectPosition}) : super(key: key);

  final Function? onSelectPosition;
  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;

  @override
  void initState() {
    super.initState();
    _getCurrentUserLocation();
  }

  void _showPreview(double latitude, double longitude) {
    final staticMapImageUrl = LocationUtil.generateLocationPreviewImage(
        latitude: latitude, longitude: longitude);
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });

  }

  Future<void> _getCurrentUserLocation() async {
    final locData = await Location().getLocation();
    double latitude = locData.latitude ?? 0.00;
    double longitude = locData.longitude ?? 0.00;
    widget.onSelectPosition!(LatLng(latitude, longitude));
    _showPreview(latitude, longitude);
  }

  Future<void> _selectOnMap() async {
    final LatLng selectedPosition = await Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (ctx) => MapScreen(),
    ));

    if (selectedPosition == null) {
      return;
    }

    _showPreview(selectedPosition.latitude ?? 0.00, selectedPosition.longitude ?? 0.00);
    widget.onSelectPosition!(LatLng(selectedPosition.latitude, selectedPosition.longitude));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          child: _previewImageUrl == null
              ? const Text("Location not found")
              : Image.network(
                  _previewImageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text("Current Location"),
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.primary)),
              onPressed: _getCurrentUserLocation,
            ),
            TextButton.icon(
              icon: const Icon(Icons.map),
              label: const Text("Select on map"),
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.primary)),
              onPressed: _selectOnMap,
            ),
          ],
        )
      ],
    );
  }
}
