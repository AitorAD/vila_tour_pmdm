import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vila_tour_pmdm/src/languages/app_localizations.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/providers/review_provider.dart';
import 'package:vila_tour_pmdm/src/services/config.dart';

class FavoriteFloatingActionButton extends StatefulWidget {
  final Article article;

  const FavoriteFloatingActionButton({super.key, required this.article});

  @override
  _FavoriteFloatingActionButtonState createState() =>
      _FavoriteFloatingActionButtonState();
}

class _FavoriteFloatingActionButtonState
    extends State<FavoriteFloatingActionButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final reviewProvider = Provider.of<ReviewProvider>(context);
    final isFavourite = widget.article.reviews.any(
      (review) => review.id.userId == currentUser.id && review.favorite,
    );

    return FloatingActionButton(
      onPressed: () async {
        if (isLoading) return;

        setState(() {
          isLoading = true;
        });

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
      backgroundColor: isFavourite ? Colors.white : Colors.redAccent,
      child: isFavourite
          ? const Icon(Icons.favorite, color: Colors.redAccent)
          : const Icon(Icons.favorite_border),
    );
  }
}
