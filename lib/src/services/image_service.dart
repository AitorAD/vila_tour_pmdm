import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:vila_tour_pmdm/src/models/article.dart';
import 'package:vila_tour_pmdm/src/prefs/user_preferences.dart';
import 'package:vila_tour_pmdm/src/services/config.dart';
import 'package:vila_tour_pmdm/src/models/image.dart' as customImage;
import 'dart:developer';

class ImageService {
  Future<List<customImage.Image>> getImagesByArticle(Article article) async {
    final url = Uri.parse('$baseURL/images/getImagesByArticle/${article.id}');

    String? token = await UserPreferences.instance.readData('token');

    final response = await http.get(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    final jsonResponse =
        jsonDecode(const Utf8Decoder().convert(response.bodyBytes));

    List<customImage.Image> images =
        customImage.Image.fromJsonList(jsonResponse);
    return images;
  }

  Future<customImage.Image> getImageByArticle(Article article) async {
    final url = Uri.parse('$baseURL/images/getImageByArticle/${article.id}');

    String? token = await UserPreferences.instance.readData('token');

    final response = await http.get(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    customImage.Image image = customImage.Image.fromJson(response.body);
    return image;
  }

  Future<customImage.Image> uploadImage(customImage.Image image) async {
    final url;
    if (image.article != null) {
      url = Uri.parse(
          '$baseURL/images/withArticle?id_article=${image.article!.id}');
    } else {
      url = Uri.parse('$baseURL/images');
    }
    String? token = await UserPreferences.instance.readData('token');
    if (token == null) {
      throw Exception('Token is null');
    }

    try {
      final String jsonBody = jsonEncode(image.toMap());

      final response = await http.post(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: jsonBody,
      );

      log("PRINT DE CONTROL TOTAL: " + jsonBody);

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return customImage.Image.fromMap(responseData);
      } else {
        throw HttpException(
            'Failed to upload image: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      rethrow;
    }
  }
}

// localhost:8080/images?id_article=21321