import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:news/model/models.dart';
import 'package:news/screens/news_detail.dart';
import 'package:transparent_image/transparent_image.dart';

class ArticleItemWidget extends StatelessWidget {
  final Article article;

  ArticleItemWidget({Key key, @required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(article.url),
      onDismissed: (direction) {


        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text("Новину збережено")));
      },
      child: Card(
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ArticleDetailScreen(article: article),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.only(left: 16),
            child: Container(
              height: 100,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          article.title,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Align(
                          child: Text(
                            "${article.source.name} - ${formatDateTime(article.publishedAt)}",
                            maxLines: 1,
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  getWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getWidget() {
    if (article.urlToImage != null) {
      return FadeInImage.memoryNetwork(
        placeholder: kTransparentImage,
        image: article.urlToImage,
        height: 100,
        width: 125,
        fit: BoxFit.cover,
      );
    } else {
      return Center(
        child: Container(
          child: Icon(Icons.photo_camera),
          width: 100,
          height: 125,
        ),
      );
    }
  }

  String formatDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    var formatter = DateFormat('dd.MM.yyyy HH:mm');
    return formatter.format(dateTime);
  }
}
