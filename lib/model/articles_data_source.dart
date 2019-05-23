import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news/model/models.dart';

class ArticlesDataSource {
  static final String baseUrl = 'https://newsapi.org/v2/';
  static final String apiKeyParam = '?apiKey=8c655aa98f4a488aa4dcafff411952d5';

  static Future<ArticlesResponse> getTop(int page) async {
    final response = await http
        .get('${baseUrl}top-headlines$apiKeyParam&country=ua&page=$page');
    final responseJson = json.decode(response.body.toString());

    printWrapped(responseJson.toString());

    var parsedResponse = ArticlesResponse.fromMap(responseJson);

    return parsedResponse;
  }

  static Future<List<Article>> getAll(int page) async {
    final response = await http
        .get('${baseUrl}everything$apiKeyParam&language=ru&page=$page');
    final responseJson = json.decode(response.body.toString());

    print(responseJson);

    List rawArticles = responseJson['articles'];
    return rawArticles.map((map) => Article.fromMap(map)).toList();
  }

  static printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }
}
