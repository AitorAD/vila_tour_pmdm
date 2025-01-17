import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/providers/providers.dart';
import 'package:vila_tour_pmdm/src/screens/screens.dart';
import 'package:vila_tour_pmdm/src/services/config.dart';
import 'package:vila_tour_pmdm/src/services/review_service.dart';
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
        if (widget.article is Place) _routeName = PlacesDetails.routeName,
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
            if (widget.article is Place) _PlaceInfo(widget: widget),
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
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      right: 10,
      child: GestureDetector(
        onTap: () async {
          if (isLoading) return;

          setState(() {
            isLoading = true;
          });

          final reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
          final currentReview = widget.article.reviews.firstWhere(
            (review) => review.id.userId == currentUser.id,
            orElse: () => Review(
              id: ReviewId(articleId: widget.article.id, userId: currentUser.id),
              favorite: false,
              comment: "",
              postDate: DateTime.now(),
              rating: 0,
            ),
          );

          try {
            await reviewProvider.toggleFavorite(currentReview);
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error al actualizar el estado de favorito'),
                backgroundColor: Colors.red,
              ),
            );
          } finally {
            setState(() {
              isLoading = false;
            });
          }
        },
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(child: child, scale: animation);
          },
          child: Icon(
            getFavourite() ? Icons.favorite : Icons.favorite_border,
            key: ValueKey<bool>(getFavourite()),
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }

  bool getFavourite() {
    return widget.article.reviews.any(
      (review) => review.id.userId == currentUser.id && review.favorite,
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
                  (widget.article as Festival).averageScore.toStringAsFixed(1),
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

class _PlaceInfo extends StatelessWidget {
  const _PlaceInfo({
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
              'Lugar: ${(widget.article as Place).coordinate.name}',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                PaintStars(
                    rating: (widget.article as Place).averageScore,
                    color: Colors.yellow),
                SizedBox(width: 10),
                Text(
                  (widget.article as Place).averageScore.toStringAsFixed(1),
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
                  (widget.article as Recipe).averageScore.toStringAsFixed(1),
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
            ? _ImageRecipe(widget: widget)
            : _ImageFestival(widget: widget),
      ),
    );
  }
}

class _ImageRecipe extends StatelessWidget {
  const _ImageRecipe({
    super.key,
    required this.widget,
  });

  final ArticleBox widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.4),
      height: 150,
      child: Row(
        children: [
          Container(
            width: 135,
            height: 150,
            child: FadeInImage(
              placeholder: AssetImage('assets/logo.ico'),
              image: widget.article.images.isNotEmpty
                  ? MemoryImage(
                      decodeImageBase64(widget.article.images.first.path))
                  : AssetImage('assets/logo_foreground.png') as ImageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageFestival extends StatelessWidget {
  const _ImageFestival({
    super.key,
    required this.widget,
  });

  final ArticleBox widget;

  @override
  Widget build(BuildContext context) {
    return FadeInImage(
      placeholder: AssetImage('assets/logo.ico'),
      image: widget.article.images.isNotEmpty
          ? MemoryImage(decodeImageBase64(widget.article.images.first.path))
          : AssetImage('assets/logo_foreground.png') as ImageProvider,
      width: double.infinity,
      height: 150,
      fit: BoxFit.cover,
    );
  }
}
