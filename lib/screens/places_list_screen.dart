import 'package:flutter/material.dart';
import 'package:great_places/models/place.dart';
import 'package:great_places/providers/great_places.dart';
import 'package:great_places/utils/app_routes.dart';
import 'package:provider/provider.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("My places"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.PLACE_FORM);
                },
                icon: const Icon(Icons.add))
          ],
        ),
        body: FutureBuilder(
          future: Provider.of<GreatPlaces>(context, listen: false).loadPlaces(),
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Consumer<GreatPlaces>(
                      child: const Center(child: Text("None place registered")),
                      builder: (context, greatPlaces, child) {
                        return greatPlaces.itemsCount == 0 && child != null
                            ? child
                            : ListView.builder(
                                itemCount: greatPlaces.itemsCount,
                                itemBuilder: (context, placeIndex) {
                                  Place currentPlace =
                                      greatPlaces.getItemByIndex(placeIndex);
                                  return _buildPlaceItem(context, currentPlace);
                                },
                              );
                      },
                    ),
        ));
  }

  Dismissible _buildPlaceItem(BuildContext context, Place place) {
    return Dismissible(
      key: ValueKey(place.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) {
        Provider.of<GreatPlaces>(context, listen: false).deleteById(place.id);
      },
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 36,
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: FileImage(
            place.image!,
          ),
        ),
        title: Text(place.title!),
        subtitle: Text(place.location?.address ?? ''),
        onTap: () => Navigator.of(context)
            .pushNamed(AppRoutes.PLACE_DETAIL, arguments: place),
      ),
    );
  }
}
