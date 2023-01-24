import 'package:flutter/material.dart';
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
          builder: (context, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
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
                            itemBuilder: (context, index) => ListTile(
                              leading: CircleAvatar(
                                backgroundImage: FileImage(
                                  greatPlaces.getItemByIndex(index).image!,
                                ),
                              ),
                              title: Text(
                                  greatPlaces.getItemByIndex(index).title!),
                              subtitle: Text(greatPlaces
                                      .getItemByIndex(index)
                                      .location
                                      ?.address ??
                                  ''),
                              onTap: () => Navigator.of(context).pushNamed(
                                  AppRoutes.PLACE_DETAIL,
                                  arguments: greatPlaces.getItemByIndex(index)),
                            ),
                          );
                  },
                ),
        ));
  }
}
