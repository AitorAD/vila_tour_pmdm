import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onFilterPressed;
  final VoidCallback? onTap; // Hacer que onTap sea opcional

  const SearchBox({
    super.key,
    required this.hintText,
    required this.controller,
    required this.onChanged,
    required this.onFilterPressed,
    this.onTap, // Añadir onTap como opcional
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: const BoxDecoration(
        color: Color.fromARGB(127, 217, 217, 217),
        borderRadius: BorderRadius.all(Radius.circular(100)),
      ),
      child: Row(
        children: [
          const Icon(Icons.search),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              onTap: onTap, // Añadir onTap al TextField
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            onPressed: onFilterPressed,
          ),
        ],
      ),
    );
  }
}