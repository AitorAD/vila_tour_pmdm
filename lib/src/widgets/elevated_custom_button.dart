import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';

class ElevatedCustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // Permite pasar una función como parámetro
  final double radius;

  const ElevatedCustomButton({
    super.key,
    required this.text,
    required this.radius,
    required this.onPressed, // Asegúrate de requerir la función
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: defaultDecoration(radius, opacity: 1), // Aplica la decoración
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // Lo hacemos transparente
          shadowColor: Colors.transparent, // Quitamos la sombra del botón
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(radius), // Bordes personalizados
          ),
        ),
        onPressed: onPressed, // Ejecuta la función pasada
        child: Text(
          text,
          style: textStyleVilaTour(color: Colors.white),
        ),
      ),
    );
  }
}
