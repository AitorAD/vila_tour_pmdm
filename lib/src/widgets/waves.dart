import 'package:flutter/material.dart';

class WavesWidget extends StatelessWidget {
  const WavesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: CustomPaint(
              size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height * 0.65),  // Altura al 65%
              painter: WavePainter(),
            ),
          ),
        ],
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color(0x0000ffb7).withOpacity(0.2)
      ..style = PaintingStyle.fill;

    // Onda inferior
    Path path = Path();
    path.moveTo(0, size.height * 0.6); // Empieza en la parte inferior (al 60%)
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.6, size.width * 0.5, size.height * 0.5); // Subida
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.4, size.width  * 1, size.height * 0.4); // Bajada del crecimiento
    path.lineTo(size.width, size.height); // Cierra el fondo
    path.lineTo(0, size.height); // Cierra el fondo
    path.close();

    canvas.drawPath(path, paint);

    // Onda superior más suave
    Paint paint2 = Paint()
      ..color = const Color(0x0000ffb7).withOpacity(0.2)
      ..style = PaintingStyle.fill;

    Path path2 = Path();
    path2.moveTo(0, size.height * 0.3); // Empieza más arriba para cubrir más pantalla
    path2.quadraticBezierTo(size.width * 0.25, size.height * 0.3, size.width * 0.5, size.height * 0.4); //Bajada
    path2.quadraticBezierTo(size.width * 0.75, size.height * 0.5, size.width, size.height * 0.5); //Baja el decrecimiento
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();

    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}