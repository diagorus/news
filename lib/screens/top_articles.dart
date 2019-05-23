import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:news/model/articles_data_source.dart';
import 'package:news/model/models.dart';
import 'package:news/screens/wigets/ArticleItemWidget.dart';

class TopArticlesWidget extends StatefulWidget {
  @override
  _TopArticlesState createState() => _TopArticlesState();
}

class _TopArticlesState extends State<TopArticlesWidget> {
  ScrollController _controller =
  ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);

  List<Article> items = [];

  int _total = -1;

  int currentPage = 0;
  bool isLoading = false;

  _TopArticlesState() {
    _controller.addListener(() {
      bool isEnd = _controller.offset == _controller.position.maxScrollExtent;
      if (isEnd && items.length < _total)
        setState(() {
          _loadData();
        });
    });
  }

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return _getScreenWidget();
  }

  Widget _getScreenWidget() {
    if (isLoading && currentPage == 1) {
      return Center(child: CircularProgressIndicator());
    } else {
      return ListView.builder(
        controller: _controller,
        itemCount: items.length == _total ? items.length : items.length + 1,
        itemBuilder: (context, index) {
          if (index == items.length) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: CircularProgressIndicator(),
                alignment: Alignment.center,
              ),
            );
          } else {
            Article article = items[index];
            return ArticleItemWidget(article: article);
          }
        },
      );
    }
  }

  _loadData() async {
    setState(() {
      isLoading = true;
    });

    currentPage++;
    var articlesResponse = await ArticlesDataSource.getTop(currentPage);

    setState(() {
      isLoading = false;

      _total = articlesResponse.totalResults;
      items.addAll(articlesResponse.articles);
    });
  }
}
