import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vila_tour_pmdm/src/languages/app_localizations.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/providers/providers.dart';
import 'package:vila_tour_pmdm/src/screens/screens.dart';
import 'package:vila_tour_pmdm/src/services/config.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleBox extends StatefulWidget {
  final Article article;
  const ArticleBox({super.key, required this.article});
  @override
  State<ArticleBox> createState() => _ArticleBoxState();
}

class _ArticleBoxState extends State<ArticleBox> {
  @override
  Widget build(BuildContext context) {
    String routeName = "/";
    return GestureDetector(
      onTap: () => {
        if (widget.article is Festival) routeName = DetailsFestival.routeName,
        if (widget.article is Recipe) routeName = RecipeDetails.routeName,
        if (widget.article is Place) routeName = PlacesDetails.routeName,
        Navigator.pushNamed(
          context,
          routeName,
          arguments: widget.article,
        ),
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Stack(
          children: [
            _BackgroundImage(widget: widget),
            if (widget.article is Festival) _FestivalInfo(widget: widget),
            if (widget.article is Recipe) _RecipeInfo(widget: widget),
            if (widget.article is Place) _PlaceInfo(widget: widget),
            _Favorite(article: widget.article),
            if (widget.article is Festival || widget.article is Place)
              _HowToGetThere(article: widget.article),
          ],
        ),
      ),
    );
  }
}

class _Favorite extends StatefulWidget {
  const _Favorite({required this.article});

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

          final reviewProvider =
              Provider.of<ReviewProvider>(context, listen: false);
          final currentReview = widget.article.reviews.firstWhere(
            (review) => review.id.userId == currentUser.id,
            orElse: () => Review(
              id: ReviewId(
                  articleId: widget.article.id, userId: currentUser.id),
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
                content: Text(
                    AppLocalizations.of(context).translate('updateFavError')),
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
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
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

class _HowToGetThere extends StatelessWidget {
  const _HowToGetThere({required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 15,
      right: 10,
      child: GestureDetector(
        onTap: () async {
          Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);
          String destination;
          if (article is Place) {
            destination =
                '${(article as Place).coordinate.latitude},${(article as Place).coordinate.longitude}';
          } else if (article is Festival) {
            destination =
                '${(article as Festival).coordinate.latitude},${(article as Festival).coordinate.longitude}';
          } else {
            return;
          }
          String url =
              'https://www.google.com/maps/dir/?api=1&origin=${position.latitude},${position.longitude}&destination=$destination&travelmode=driving';
          if (await canLaunchUrl(Uri.parse(url))) {
            await launchUrl(Uri.parse(url));
          } else {
            throw 'Could not launch url';
          }
        },
        child: const Icon(Icons.directions, color: Colors.white, size: 30),
      ),
    );
  }
}

class _FestivalInfo extends StatelessWidget {
  const _FestivalInfo({
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
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.article.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "${AppLocalizations.of(context).translate('place')}: ${(widget.article as Festival).coordinate.name}",
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            Text(
              '${formatDate((widget.article as Festival).startDate)} - ${formatDate((widget.article as Festival).endDate)}',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                PaintStars(
                    rating: (widget.article as Festival).averageScore,
                    color: Colors.yellow),
                const SizedBox(width: 10),
                Text(
                  (widget.article as Festival).averageScore.toStringAsFixed(1),
                  style: const TextStyle(
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
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.article.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${AppLocalizations.of(context).translate('place')}: ${(widget.article as Place).coordinate.name}',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                PaintStars(
                    rating: (widget.article as Place).averageScore,
                    color: Colors.yellow),
                const SizedBox(width: 10),
                Text(
                  (widget.article as Place).averageScore.toStringAsFixed(1),
                  style: const TextStyle(
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
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 135),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
              color: Colors.black.withOpacity(0.4),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.article.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    PaintStars(
                        rating: (widget.article as Recipe).averageScore,
                        color: Colors.yellow),
                    const SizedBox(width: 10),
                    Text(
                      (widget.article as Recipe).averageScore.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if ((widget.article as Recipe).approved != null && !(widget.article as Recipe).approved!)
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context).translate('disapproved'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BackgroundImage extends StatelessWidget {
  const _BackgroundImage({
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
          SizedBox(
            width: 135,
            height: 150,
            child: FadeInImage(
              placeholder: const AssetImage('assets/logo.ico'),
              image: widget.article.images.isNotEmpty
                  ? MemoryImage(
                      decodeImageBase64(widget.article.images.first.path))
                  : const AssetImage('assets/logo_foreground.png')
                      as ImageProvider,
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
    required this.widget,
  });

  final ArticleBox widget;

  @override
  Widget build(BuildContext context) {
    return FadeInImage(
      placeholder: const AssetImage('assets/logo.ico'),
      image: widget.article.images.isNotEmpty
          ? MemoryImage(decodeImageBase64(widget.article.images.first.path))
          : const AssetImage('assets/logo_foreground.png') as ImageProvider,
      width: double.infinity,
      height: 150,
      fit: BoxFit.cover,
    );
  }
}
