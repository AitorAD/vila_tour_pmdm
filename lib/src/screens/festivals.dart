import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';

class FestivalsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Festivales y Tradiciones',
            style: Utils.textStyleVilaTour,
          ),
          flexibleSpace: DefaultDecoration(),
          foregroundColor: Colors.white,
        ),
        body: Column(
          children: [
            SearchBox(),
            FestivalBox(),
            FestivalBox(),
          ],
        ));
  }
}

class FestivalBox extends StatelessWidget {
  const FestivalBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
