import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:news/models.dart';
import 'package:news/screens/wigets/ArticleItemWidget.dart';

class TopArticlesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchNews(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                Article article = snapshot.data[index];

                return ArticleItemWidget(article: article);
              });
        } else if (snapshot.hasError) {
          return Center(child: Text("${snapshot.error}"));
        }

        // By default, show a loading spinner
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Future<List<Article>> fetchNews() async {
    final response = await http.get(
        'https://newsapi.org/v2/top-headlines?country=ua&apiKey=8c655aa98f4a488aa4dcafff411952d5');
    final responseJson = json.decode(response.body.toString());

    print(responseJson);

    List rawArticles = responseJson['articles'];
    return rawArticles.map((rawArticle) {
      final String sourceId = rawArticle['source']['id'];
      final String sourceName = rawArticle['source']['name'];

      final String author = rawArticle['author'];
      final String title = rawArticle['title'];
      final String description = rawArticle['description'];
      final String url = rawArticle['url'];
      final String urlToImage = rawArticle['urlToImage'];
      final String publishedAt = rawArticle['publishedAt'];
      final String content = rawArticle['content'];

      return Article(Source(sourceId, sourceName), author, title, description,
          url, urlToImage, publishedAt, content);
    }).toList();
  }
}
