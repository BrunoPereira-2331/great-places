import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/models/place.dart';

class MapScreen extends StatefulWidget {
  MapScreen({
    Key? key,
    this.initialLocation = const PlaceLocation(
      latitude: 37.3861,
      longitude: 122.0839,
    ),
    this.isReadonly = false,
  }) : super(key: key);
  final PlaceLocation initialLocation;
  final bool isReadonly;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedPosition;

  void _selectPosition(LatLng position) {
    setState(() {
      _pickedPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select the location"),
        actions: [
          if (!widget.isReadonly)
            IconButton(
                onPressed: _pickedPosition == null
                    ? () {}
                    : () => Navigator.of(context).pop(_pickedPosition),
                icon: const Icon(Icons.check))
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
            target: LatLng(widget.initialLocation.latitude,
                widget.initialLocation.longitude)),
        onTap: widget.isReadonly ? null : _selectPosition,
        markers: (_pickedPosition != null && !widget.isReadonly)
            ? {
                Marker(
                  markerId: const MarkerId('p1'),
                  position:
                      _pickedPosition ?? widget.initialLocation.toLatLgn(),
                ),
              }
            : {},
      ),
    );
  }
}
