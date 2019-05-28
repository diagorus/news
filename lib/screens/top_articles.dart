import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:news/model/articles_data_source.dart';
import 'package:news/model/models.dart';
import 'package:news/model/presentation_models.dart';
import 'package:news/wigets/ArticleItemWidget.dart';
import 'package:news/wigets/InfiniteScrollListWidget.dart';

class TopArticlesWidget extends StatefulWidget {
  @override
  _TopArticlesState createState() => _TopArticlesState();
}

class _TopArticlesState extends State<TopArticlesWidget> {
  bool isInitialLoading = false;

  LoadedData<Article> initialData;

  @override
  void initState() {
    super.initState();

    loadInitialBatch();
  }

  @override
  Widget build(BuildContext context) {
    if (isInitialLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      return InfiniteScrollListWidget<Article>(
        initialData,
            (article) => ArticleItemWidget(article: article),
            (page) => _loadMoreItems(page),
      );
    }
  }

  loadInitialBatch() async {
    setState(() {
      isInitialLoading = true;
    });

    ArticlesResponse articlesResponse = await ArticlesDataSource.getTop(1);
    initialData = articlesResponse.mapToLoadedData();

    setState(() {
      isInitialLoading = false;
    });
  }

  Future<List<Article>> _loadMoreItems(int page) async {
    ArticlesResponse articlesResponse = await ArticlesDataSource.getTop(page);
    return articlesResponse.articles;
  }
}
