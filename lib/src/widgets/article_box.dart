import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/screens/festivals_details_screen.dart';
import 'package:vila_tour_pmdm/src/screens/recipes_details_screen.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';
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
    String _routeName = "/";
    return GestureDetector(
      onTap: () => {
        if (widget.article is Festival) _routeName = DetailsFestival.routeName,
        if (widget.article is Recipe) _routeName = RecipeDetails.routeName,
        Navigator.pushNamed(
          context,
          _routeName,
          arguments: widget.article,
        ),
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Stack(
          children: [
            _BackgroundImage(widget: widget),
            if (widget.article is Festival) _FestivalInfo(widget: widget),
            if (widget.article is Recipe) _RecipeInfo(widget: widget),
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
            // widget.article.favourite = !widget.article.favourite;
          });
        },
        child: Icon(
          Icons.favorite,
          // widget.article.favourite ? Icons.favorite : Icons.favorite_border,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}

class _FestivalInfo extends StatelessWidget {
  const _FestivalInfo({
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
            Text(
              'Lugar: ${(widget.article as Festival).coordinate.name}',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            Text(
              '${formatDate((widget.article as Festival).startDate)} - ${formatDate((widget.article as Festival).endDate)}',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                PaintStars(
                    rating: (widget.article as Festival).averageScore,
                    color: Colors.yellow),
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

class _RecipeInfo extends StatelessWidget {
  const _RecipeInfo({
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
        margin: EdgeInsets.only(left: 135),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
          color: Colors.black.withOpacity(0.4),
        ),
        padding: EdgeInsets.all(20),
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
            SizedBox(height: 5),
            Row(
              children: [
                PaintStars(
                    rating: (widget.article as Recipe).averageScore,
                    color: Colors.yellow),
                SizedBox(width: 10),
                Text(
                  (widget.article as Recipe).averageScore.toString(),
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
      child: Hero(
        tag: widget.article.id,
        child: widget.article is Recipe
            ? Container(
                color: Colors.black.withOpacity(0.4),
                height: 150,
                child: Row(
                  children: [
                    Container(
                      width: 135,
                      height: 150,
                      child: FadeInImage(
                        placeholder: AssetImage('assets/logo.ico'),
                        image: MemoryImage(decodeImageBase64(
                            widget.article.images!.first.path)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              )
            : FadeInImage(
                placeholder: AssetImage('assets/logo.ico'),
                image: MemoryImage(
                    decodeImageBase64(widget.article.images![0].path)),
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
