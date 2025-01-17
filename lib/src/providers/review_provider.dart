import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/services/review_service.dart';

class ReviewProvider extends ChangeNotifier {
  final ReviewService _reviewService = ReviewService();

  Future<void> toggleFavorite(Review review) async {
    review.favorite = !review.favorite;
    try {
      bool response = await _reviewService.addUpdateReview(review);
      if (response) notifyListeners();
    } catch (e) {
      review.favorite = !review.favorite;
      notifyListeners();
      throw e;
    }
  }
}