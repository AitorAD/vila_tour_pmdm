import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/services/place_service.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';

class PlacesScreen extends StatelessWidget {
  static final routeName = 'places_screen';
  const PlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final placeService = PlaceService();

    return Scaffold(
      bottomNavigationBar: CustomNavigationBar(),
      appBar: CustomAppBar(title: 'Lugares'),
      body: Stack(
        children: [
          WavesWidget(),
          FutureBuilder<List<Place>>(
            future: placeService.getPlaces(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No se encontraron lugares.'));
              } else {
                List<Place> places = snapshot.data!;

                return ListView.builder(
                  itemCount: places.length,
                  itemBuilder: (context, index) {
                    final place = places[index];
                    return ArticleBox(article: place);
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
