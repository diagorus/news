import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:news/model/articles_data_source.dart';
import 'package:news/model/models.dart';
import 'package:news/screens/wigets/ArticleItemWidget.dart';

class AllArticlesWidget extends StatefulWidget {
  @override
  _AllArticlesState createState() => _AllArticlesState();
}

class _AllArticlesState extends State<AllArticlesWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ArticlesDataSource.getAll(1),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              Article article = snapshot.data[index];
              return ArticleItemWidget(article: article);
            },
          );
        } else if (snapshot.hasError) {
          return Center(child: Text("${snapshot.error}"));
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
