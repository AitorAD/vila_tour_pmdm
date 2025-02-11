import 'dart:convert';
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

  Future<List<Review>> getReviewsUser(int id) async {
    final url = Uri.parse(
        '$baseURL/reviews/byUser/byUser?idUser=$id');

    String? token = await UserPreferences.instance.readData('token');

    final response = await http.get(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      try {
        final List<dynamic> jsonResponse = json.decode(response.body);
        List<Review> reviews = jsonResponse.map((e) => Review.fromMap(e)).toList();
        return reviews;
      } catch (e) {
        throw Exception('Error al deserializar los datos de las reviews');
      }
    } else {
      throw Exception('Error al cargar los datos de las reviews');
    }
    
  }


}
