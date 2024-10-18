import 'package:flutter/material.dart';

class FestivalsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Title()), body: null);
  }
}

class Title extends StatelessWidget {
  const Title({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF4FC3F6).withOpacity(0.75), // Azul 50%
              Color(0xFF44C1CF).withOpacity(0.75), // Azul 50%
              Color(0xFF25C1CE).withOpacity(0.75), // Azul 50%
              Color(0xFF17BFC1).withOpacity(0.75), // Cian 0%
              Color(0xFF01C2A9).withOpacity(0.75), // Cian 75%
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 20,
            ),
            Text(
              'Festivales y Tradiciones',
              style: TextStyle(color: Colors.white, fontFamily: 'PontanoSans'),
            )
          ],
        ));
  }
}
