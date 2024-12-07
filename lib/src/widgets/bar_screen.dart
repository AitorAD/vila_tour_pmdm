import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';

class BarScreenArrow extends StatelessWidget {
  final String? labelText;
  final VoidCallback onBackPressed;

  const BarScreenArrow({
    super.key,
    this.labelText,
    required this.onBackPressed, // Este parámetro es obligatorio
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: defaultDecoration(0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: onBackPressed, // Llama al callback al presionar
              child: Icon(Icons.arrow_back, color: Colors.white),
            ),
            Text(
              labelText ?? "",
              style: textStyleVilaTourTitle(color: Colors.white),
            ),
            Icon(
              Icons.arrow_back,
              color: Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
