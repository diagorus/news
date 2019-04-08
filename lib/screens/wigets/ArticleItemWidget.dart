import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:news/models.dart';

import 'package:news/screens/news_detail.dart';

class ArticleItemWidget extends StatelessWidget {
  final Article article;

  ArticleItemWidget({Key key, @required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Container(
        child: GestureDetector(
          child: Text(
            article.title,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ArticleDetailScreen(
                      article: article,
                    ),
              ),
            );
          },
        ),
      ),
    );
  }
}
