import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/prefs/user_preferences.dart';
import 'package:vila_tour_pmdm/src/services/config.dart';

class ArticleService {
  Future<List<Article>> getLastArticles() async {
    final url = Uri.parse('$baseURL/articles/last');

    String? token = await UserPreferences.instance.readData('token');

    final response = await http.get(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    final jsonResponse = jsonDecode(const Utf8Decoder().convert(response.bodyBytes));

    List<Article> articles = Article.fromJsonList(jsonResponse);

    return articles;
  }

  Future<Article> getArticleById(int id) async {
    final url = Uri.parse('$baseURL/articles/$id');

    String? token = await UserPreferences.instance.readData('token');

    final response = await http.get(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    final jsonResponse = jsonDecode(const Utf8Decoder().convert(response.bodyBytes));

    Article article = Article.fromJson(jsonResponse);

    return article;
  }
}
