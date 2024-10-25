import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vila_tour_pmdm/src/models/festival.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';

import '../providers/festivals_provider.dart';

class FestivalsScreen extends StatelessWidget {
  const FestivalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Provisional hasta conectar con la API
    final festivasProvider = Provider.of<FestivalsProvider>(context);

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
                  child: ListView.builder(
                    itemCount: festivasProvider.festivals.length,
                    itemBuilder: (context, index) {
                      return _FestivalBox(festival: festivasProvider.festivals[index],);
                    },
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}

class _FestivalBox extends StatefulWidget {
  final Festival festival;

  _FestivalBox({required this.festival});

  @override
  State<_FestivalBox> createState() => _FestivalBoxState();
}

class _FestivalBoxState extends State<_FestivalBox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, 'general_festivals',
          arguments: widget.festival),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Stack(
          children: [
            // Imagen de fondo
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: AssetImage('assets/logo.ico'),
                image: NetworkImage(widget.festival.imageUrl),
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
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
                      widget.festival.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      widget.festival.location,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      widget.festival.date,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        PaintStars(rating: widget.festival.rating),
                        SizedBox(width: 10),
                        Text(
                          widget.festival.rating.toString(),
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
              child: GestureDetector(
                onTap: () => setState(() {
                  widget.festival.favourite = !widget.festival.favourite;
                }),
                child: Icon(
                  widget.festival.favourite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
