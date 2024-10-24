import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/models/festival.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';

class GeneralFestivalsScreen extends StatelessWidget {
  const GeneralFestivalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Festival festival =
        ModalRoute.of(context)!.settings.arguments as Festival;

    return Scaffold(
      appBar: AppBar(
        title: Text('Visión General', style: Utils.textStyleVilaTour),
        flexibleSpace: DefaultDecoration(),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          WavesWidget(),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Hero animation for image
                Hero(
                  tag: festival.imageUrl,
                  child: Image.network(
                    festival.imageUrl,
                    width: double.infinity,
                    height: 400,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16), // Extra spacing

                // Festival title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    festival.title,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      festival.rating.toString(),
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'PontanoSans',
                      ),
                    ),
                    const SizedBox(width: 4),
                    Row(
                      children: List.generate(4, (index) {
                        return const Icon(
                          Icons.star,
                          color: Color(0xFFEFCE4A),
                          size: 20,
                        );
                      }),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      '(281)',
                      style: TextStyle(fontSize: 16),
                    )
                  ],
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
                        festival.location,
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
      // Floating action button for "share" or "favorite"
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Acción de compartir o favorito
        },
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.favorite_border),
      ),
    );
  }
}
