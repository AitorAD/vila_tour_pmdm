import 'package:flutter/material.dart';

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