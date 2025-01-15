import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/services/review_service.dart';

class ReviewProvider with ChangeNotifier {
  final ReviewService _reviewService = ReviewService();

  List<Review> _reviews = [];
  List<Review> get reviews => _reviews;

  Future<void> toggleFavorite(Review review) async {
    review.favorite = !review.favorite;
    try {
      await _reviewService.addUpdateReview(review);
      notifyListeners();
    } catch (e) {
      review.favorite = !review.favorite;
      notifyListeners();
      throw e;
    }
  }
}