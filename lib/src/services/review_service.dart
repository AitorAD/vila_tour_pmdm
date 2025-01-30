import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/prefs/user_preferences.dart';
import 'package:vila_tour_pmdm/src/services/config.dart';

class ReviewService {
  Future<bool> addUpdateReview(Review review) async {
    final url = Uri.parse(
        '$baseURL/reviews?article_id=${review.id.articleId}&user_id=${review.id.userId}');

    String? token = await UserPreferences.instance.readData('token');

    final response = await http.post(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
      body: review.toJson(),
    );

    return response.statusCode == 200;
  }
}
