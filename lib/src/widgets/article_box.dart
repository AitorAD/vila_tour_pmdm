import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/models/article.dart';
import 'package:vila_tour_pmdm/src/models/festival.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';

class ArticleBox extends StatefulWidget {
  final Article article;

  ArticleBox({required this.article});

  @override
  State<ArticleBox> createState() => _ArticleBoxState();
}

class _ArticleBoxState extends State<ArticleBox> {
  @override
  Widget build(BuildContext context) {
    String routeName = "/";
    return GestureDetector(
      onTap: () => {
        if (widget.article is Festival) routeName = 'general_festivals',
        // if (widget.article is Recipe) routeName = 'general_recipes', 
        Navigator.pushNamed(
          context,
          routeName,
          arguments: widget.article,
        ),
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Stack(
          children: [
            // Imagen de fondo
            _BackgroundImage(widget: widget),

            // Información sobre el artículo
            _ArticleInfo(widget: widget),

            // Icono de favorito
            _Favorite(article: widget.article)
          ],
        ),
      ),
    );
  }
}

class _Favorite extends StatefulWidget {
  const _Favorite({super.key, required this.article});

  final Article article;

  @override
  State<_Favorite> createState() => __FavoriteState();
}

class __FavoriteState extends State<_Favorite> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      right: 10,
      child: GestureDetector(
        onTap: () {
          setState(() {
            widget.article.favourite = !widget.article.favourite;
          });
        },
        child: Icon(
          widget.article.favourite ? Icons.favorite : Icons.favorite_border,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}

class _ArticleInfo extends StatelessWidget {
  const _ArticleInfo({
    super.key,
    required this.widget,
  });

  final ArticleBox widget;

  @override
  Widget build(BuildContext context) {
    return Positioned(
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
              widget.article.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (widget.article is Festival)
              Text(
                (widget.article as Festival).location,
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            if (widget.article is Festival)
              Text(
                (widget.article as Festival).date,
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            SizedBox(height: 10),
            if (widget.article is Festival)
              Row(
                children: [
                  PaintStars(rating: (widget.article as Festival).averageScore),
                  SizedBox(width: 10),
                  Text(
                    (widget.article as Festival).averageScore.toString(),
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
    );
  }
}

class _BackgroundImage extends StatelessWidget {
  const _BackgroundImage({
    super.key,
    required this.widget,
  });

  final ArticleBox widget;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: FadeInImage(
        placeholder: AssetImage('assets/logo.ico'),
        image: NetworkImage(widget.article.imagePath),
        width: double.infinity,
        height: 150,
        fit: BoxFit.cover,
      ),
    );
  }
}
