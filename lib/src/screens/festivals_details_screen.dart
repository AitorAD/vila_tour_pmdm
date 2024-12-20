import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';

class DetailsFestival extends StatefulWidget {
  static final routeName = 'general_festival';
  const DetailsFestival({super.key});

  @override
  State<DetailsFestival> createState() => _DetailsFestivalState();
}

class _DetailsFestivalState extends State<DetailsFestival> {
  @override
  Widget build(BuildContext context) {
    final Festival festival =
        ModalRoute.of(context)!.settings.arguments as Festival;

    return Scaffold(
      appBar: CustomAppBar(title: 'Visión General'),
      body: Stack(
        children: [
          WavesWidget(),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Hero(
                  tag: festival.id, // Asegúrate de usar el mismo `tag`
                  child: FadeInImage(
                    placeholder: AssetImage('assets/logo.ico'),
                    image: MemoryImage(
                        decodeImageBase64(festival.images!.first.path)),
                    width: double.infinity,
                    height: 400,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 16),

                // Festival title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    festival.name,
                    style: const TextStyle(
                      fontFamily: 'PontanoSans',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 8),

                // Row for rating stars
                Container(
                  width: 300,
                  height: 50,
                  decoration: defaultDecoration(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        festival.averageScore.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'PontanoSans',
                        ),
                      ),
                      const SizedBox(width: 4),
                      PaintStars(
                          rating: festival.averageScore, color: Colors.yellow),
                      const SizedBox(width: 4),
                      Text(
                        '(${festival.reviews.length})',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      )
                    ],
                  ),
                ),

                const Divider(),

                // Festival description
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    festival.description,
                    style: const TextStyle(
                      fontFamily: 'PontanoSans',
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ),

                const Divider(),

                // Location row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_on, color: Colors.redAccent),
                      const SizedBox(width: 4),
                      Text(
                        '${festival.coordinate.name} [${festival.coordinate.latitude}, ${festival.coordinate.longitude}]',
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'PontanoSans',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
      /*

      // Floating action button for "favorite"

      // El widget consumer reconstruye automaticamente el floatingActionButton
      // cuando es estado de FestivalsProvider cambia
      floatingActionButton: Consumer<FestivalsProvider>(
        builder: (context, festivalsProvider, child) {
          // Verifica si el festival actual es favorito
          final isFavourite = festivalsProvider.festivals
              .any((f) => f.name == festival.name && f.favourite);

          return FloatingActionButton(
            onPressed: () {
              festivalsProvider.toggleFavorite(festival);
            },
            backgroundColor: isFavourite ? Colors.white : Colors.redAccent,
            child: isFavourite
                ? Icon(Icons.favorite, color: Colors.redAccent)
                : Icon(Icons.favorite_border),
          );
        },
      ),

      */
    );
  }
}
