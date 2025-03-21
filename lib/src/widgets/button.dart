import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';

class CustomButton extends StatelessWidget {
  final String text; // Texto que se pasará al botón
  final VoidCallback? onPressed; // Función a ejecutar al presionar el botón
  final double radius; // Radio de las esquinas del botón
  final double width; // Ancho fijo del botón
  final double height; // Altura fija del botón

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.radius = 40, // Valor predeterminado para el radio
    this.width = 150, // Ancho predeterminado
    this.height = 50, // Altura predeterminada
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed, // Llama a la función onPressed al tocar
      child: SizedBox(
        width: width,
        height: height,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: defaultDecoration(radius), // Aplica la decoración
          child: Center(
            child: Text(
              text,
              style: textStyleVilaTour(color: Colors.white), // Color del texto
            ),
          ),
        )
      ),
    );
  }
}