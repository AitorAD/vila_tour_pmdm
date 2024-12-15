import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:vila_tour_pmdm/src/models/article.dart';
import 'package:vila_tour_pmdm/src/prefs/user_preferences.dart';
import 'package:vila_tour_pmdm/src/services/config.dart';
import 'package:vila_tour_pmdm/src/models/image.dart' as customImage;

class ImageService {

  Future<List<customImage.Image>> getImagesByArticle(Article article) async {
    final url = Uri.parse('$baseURL/images/byArticle/${article.id}');

    String? token = await UserPreferences.instance.readData('token');

    final response = await http.get(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    List<customImage.Image> images = customImage.Image.fromJsonList(jsonDecode(response.body));

    for (var image in images) {
      image.article = article;
      print(image);
    }

    return images;
  }

}
