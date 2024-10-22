import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/widgets/default_decoration.dart';
import 'package:vila_tour_pmdm/src/widgets/search_box.dart';
import 'package:vila_tour_pmdm/src/widgets/waves.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';

class FestivalsScreen extends StatelessWidget {
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
                      FestivalBox(
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

/*
class FestivalBox extends StatelessWidget {
  const FestivalBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, 'general_festivals'),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            image: DecorationImage(
                image: NetworkImage(
                    'https://estaticos-cdn.prensaiberica.es/clip/1bffb2d9-4536-4676-9878-f7bc72f75cc4_16-9-discover-aspect-ratio_default_0.jpg'),
                fit: BoxFit.cover)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image(
              image: NetworkImage(
                  'https://admin.vila.softme.es/Files/Img?url=~%2FApp_Data%2FUploadedFiles%2FJunio%202024%2F20240521041824Pebrereta.jpg&sz=100&ql=50'),
              width: 20,
              fit: BoxFit.cover,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
              decoration: BoxDecoration(
                  color: Color(0xFFA0D6F1).withOpacity(0.80),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'La Pebrereta',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'PontanoSans',
                        fontSize: 24),
                  ),
                  Text('Plaza de la Luz - Poble Nou'),
                  Text('14 Junio'),
                  Row(
                    children: [
                      Row(children: [
                        Icon(Icons.star, color: Color(0xFFEFCE4A)),
                        Icon(Icons.star, color: Color(0xFFEFCE4A)),
                        Icon(Icons.star, color: Color(0xFFEFCE4A)),
                        Icon(Icons.star, color: Color(0xFFEFCE4A)),
                        Icon(Icons.star, color: Colors.grey),
                      ]),
                      Text('4,9'),
                      Icon(Icons.favorite, color: Color(0xFFD7443E))
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
*/

class FestivalBox extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String location;
  final String date;
  final double rating;

  FestivalBox({
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
