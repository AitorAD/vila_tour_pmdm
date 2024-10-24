import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';

class FestivalsScreen extends StatelessWidget {
  const FestivalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /*
    var festivales = [
      {},
      {},
    ];
    */
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Festivales y Tradiciones',
            style: Utils.textStyleVilaTour,
          ),
          flexibleSpace: DefaultDecoration(),
          foregroundColor: Colors.white,
        ),
        body: Stack(
          children: [
            WavesWidget(),
            Column(
              children: [
                SearchBox(),
                Expanded(
                  child: ListView(
                    children: [
                      _FestivalBox(
                        imageUrl: 'https://www.elperiodic.com/archivos/imagenes/noticias/2024/06/15/20240614-221327.jpg',
                        title: 'Sant Miquel',
                        location: 'Plaza de la Iglesia - La Ermita',
                        date: '26 - 29 Septiembre',
                        rating: 4.7,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}

class _FestivalBox extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String location;
  final String date;
  final double rating;

  _FestivalBox({
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.date,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Stack(
        children: [
          // Imagen de fondo
          Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Información sobre el festival
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black.withOpacity(0.4),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    location,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    date,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.yellow),
                          Icon(Icons.star, color: Colors.yellow),
                          Icon(Icons.star, color: Colors.yellow),
                          Icon(Icons.star, color: Colors.yellow),
                          Icon(Icons.star_border, color: Colors.yellow),
                        ],
                      ),
                      Text(
                        rating.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Icono de favorito
          Positioned(
            top: 10,
            right: 10,
            child: Icon(
              Icons.favorite_border,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
