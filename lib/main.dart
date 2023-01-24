import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:great_places/providers/great_places.dart';
import 'package:great_places/screens/place_detail_screen.dart';
import 'package:great_places/screens/place_form_screen.dart';
import 'package:great_places/screens/places_list_screen.dart';
import 'package:great_places/utils/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const App());
}

setSharedPreferencesData() async {
  await DotEnv().load(fileName: '.env');
  Future<SharedPreferences> shared = SharedPreferences.getInstance();
  shared.then((sharedData) {
    String googleMapsApiKey = DotEnv().env['GOOGLE_MAPS_API_KEY'] ?? "";
    sharedData.setString("google_maps_api_key", googleMapsApiKey);
  });
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    setSharedPreferencesData();

    final ThemeData theme = ThemeData();
    return ChangeNotifierProvider(
      create: (ctx) => GreatPlaces(),
      child: MaterialApp(
        title: 'Great Places',
        theme: theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(
            primary: Colors.indigo,
            secondary: Colors.amber,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const PlacesList(),
        routes: {
          AppRoutes.PLACE_FORM: (context) => const PlaceFormScreen(),
          AppRoutes.PLACE_DETAIL: (context) => const PlaceDetailScreen(),
        },
      ),
    );
  }
}
