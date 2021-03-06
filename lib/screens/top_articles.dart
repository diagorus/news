import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:news/model/articles_data_source.dart';
import 'package:news/model/models.dart';
import 'package:news/model/presentation_models.dart';
import 'package:news/wigets/ArticleItemWidget.dart';
import 'package:news/wigets/InfiniteScrollListWidget.dart';

class TopArticlesWidget extends StatefulWidget {
  TopArticlesWidget(Key key, this.languageCode) : super(key: key);

  final String languageCode;

  @override
  _TopArticlesState createState() => _TopArticlesState(languageCode);
}

class _TopArticlesState extends State<TopArticlesWidget> {
  bool isInitialLoading = false;

  LoadedData<Article> initialData;

  final String languageCode;

  _TopArticlesState(this.languageCode);

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
      return InfiniteScrollListWidget(
        initialItems: initialData,
        onCreateItem: (article) => ArticleItemWidget(article),
        onLoadMore: (page) => _loadMoreItems(page),
      );
    }
  }

  loadInitialBatch() async {
    setState(() {
      isInitialLoading = true;
    });

    ArticlesResponse articlesResponse =
    await ArticlesDataSource.getTop(1, languageCode);
    initialData = articlesResponse.mapToLoadedData();

    setState(() {
      isInitialLoading = false;
    });
  }

  Future<List<Article>> _loadMoreItems(int page) async {
    ArticlesResponse articlesResponse =
    await ArticlesDataSource.getTop(page, languageCode);
    return articlesResponse.articles;
  }
}
