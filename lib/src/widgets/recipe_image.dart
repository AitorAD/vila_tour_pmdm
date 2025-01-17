import 'dart:io';
import 'package:flutter/material.dart';

class RecipeImage extends StatelessWidget {
  final String? url;

  const RecipeImage({super.key, this.url});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        left: 10,
        right: 10,
      ),
      child: Container(
        width: double.infinity,
        height: 270,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Opacity(
          opacity: 0.9,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: getImage(url),
          ),
        ),
      ),
    );
  }

  Widget getImage(String? picture) {
    if (picture == null) {
      return const Image(
        image: AssetImage('assets/placeholder_camera.png'),
        fit: BoxFit.cover,
      );
    }

    if (picture.startsWith('http')) {
      return FadeInImage(
        fit: BoxFit.cover,
        placeholder: const AssetImage('assets/logo_foreground.png'),
        image: NetworkImage(picture),
      );
    }

    return Image.file(
      File(picture),
      fit: BoxFit.cover,
    );
  }
}