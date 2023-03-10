import 'package:flutter/material.dart';
import 'package:great_places/models/place.dart';
import 'package:great_places/screens/map_screen.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Place? place = ModalRoute.of(context)?.settings.arguments as Place?;
    return Scaffold(
      appBar: AppBar(
        title: Text(place?.title ?? ''),
      ),
      body: Column(
        children: [
          Container(
            height: 250,
            width: double.infinity,
            child: Image.file(
              place!.image!,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            place.location?.address ?? "",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextButton.icon(
            icon: const Icon(Icons.map),
            label: const Text("See in map"),
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.primary)),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => MapScreen(
                isReadonly: true,
                initialLocation: place.location!,
              ),
              fullscreenDialog: true,
            )),
          )
        ],
      ),
    );
  }
}
