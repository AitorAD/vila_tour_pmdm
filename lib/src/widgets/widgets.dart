import 'package:flutter/material.dart';

class DefaultDecoration extends StatelessWidget {
  double radius;
  DefaultDecoration({super.key, this.radius = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        gradient: LinearGradient(
          colors: [
            Color(0xFF4FC3F6).withOpacity(0.75),
            Color(0xFF44C1CF).withOpacity(0.75),
            Color(0xFF25C1CE).withOpacity(0.75),
            Color(0xFF17BFC1).withOpacity(0.75),
            Color(0xFF01C2A9).withOpacity(0.75),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }
}

class SearchBox extends StatelessWidget {
  const SearchBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      decoration: const BoxDecoration(
          color: Color(0xFFD9D9D9),
          borderRadius: BorderRadius.all(Radius.circular(100))),
      child: const Row(
        children: [
          Icon(Icons.search),
          Expanded(
              child: TextField(
                  decoration: InputDecoration(
            hintText: 'Buscar',
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
          ))),
          Icon(Icons.tune_rounded),
        ],
      ),
    );
  }
}