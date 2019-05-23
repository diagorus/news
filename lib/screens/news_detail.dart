import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:news/model/models.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  ArticleDetailScreen({Key key, @required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("News detail"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Image.network(article.urlToImage),
              Text(article.title),
              Text(article.description),
              RaisedButton(
                child: Text("Go to article"),
                onPressed: () {
                  _launchURL(article.url);
                },
              )
            ],
          ),
        ));
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
