import 'dart:convert';

import 'package:http_logger/http_logger.dart';
import 'package:http_middleware/http_middleware.dart';
import 'package:news/model/models.dart';

class ArticlesDataSource {
  static final String baseUrl = 'https://newsapi.org/v2/';
  static final String apiKeyParam = '?apiKey=8c655aa98f4a488aa4dcafff411952d5';

  static Future<ArticlesResponse> getTop(int page, String language) async {
    var country = language == "uk" ? "ua" : "us";

    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final response = await http
        .get('${baseUrl}top-headlines$apiKeyParam&country=$country&page=$page');
    final responseJson = json.decode(response.body.toString());

//    printWrapped(responseJson.toString());

    return ArticlesResponse.fromMap(responseJson);
  }

  static Future<ArticlesResponse> getAll(String query, int page) async {
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final response = await http
        .get('${baseUrl}everything$apiKeyParam&q=$query&page=$page');
    final responseJson = json.decode(response.body.toString());

//    printWrapped(responseJson.toString());

    return ArticlesResponse.fromMap(responseJson);
  }

  static printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }
}
