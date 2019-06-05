import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:news/localizations.dart';
import 'package:news/model/articles_data_source.dart';
import 'package:news/model/database.dart';
import 'package:news/model/models.dart';
import 'package:news/model/presentation_models.dart';
import 'package:news/wigets/ArticleItemWidget.dart';
import 'package:news/wigets/InfiniteScrollListWidget.dart';

class SearchScreen extends StatefulWidget {
  @override
  State createState() => _SearchState();
}

class _SearchState extends State<SearchScreen> {
  final TextEditingController _searchQueryController = TextEditingController();

  bool _isSearching = false;
  String _error;
  List<Article> _results = List();
  int _total = -1;
  String currentQuery = "";

  Timer debounceTimer;

  @override
  void initState() {
    super.initState();
    _searchQueryController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchQueryController.removeListener(_onSearchChanged);
    _searchQueryController.dispose();
    super.dispose();
  }

  _onSearchChanged() {
    if (debounceTimer?.isActive ?? false) debounceTimer.cancel();

    debounceTimer = Timer(Duration(milliseconds: 500), () {
      if (this.mounted) {
        currentQuery = _searchQueryController.text;
        _performSearch(currentQuery);
      }
    });
  }

  void _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _error = null;
        _results = List();
      });

      return;
    }

    setState(() {
      _isSearching = true;
      _error = null;
      _results = List();
    });

    final articlesResponse = await ArticlesDataSource.getAll(query, 1);
    final articles = articlesResponse.articles;
    _total = articlesResponse.totalResults;

    if (this._searchQueryController.text == query && this.mounted) {
      var timestamp = DateTime.now().millisecondsSinceEpoch;
      await DBProvider.db.insertOrUpdateSearchHistory(SearchHistory(timestamp, query));

      setState(() {
        _isSearching = false;
        if (articles != null) {
          _results = articles;
        } else {
          _error = AppLocalizations.of(context).searchError;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          controller: _searchQueryController,
          style: TextStyle(color: Colors.white, fontSize: 20.0),
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context).searchHint,
            hintStyle: TextStyle(color: Colors.grey[350]),
          ),
        ),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_isSearching) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(height: 8),
            Text(AppLocalizations.of(context).searchProgress)
          ],
        ),
      );
    } else if (_error != null) {
      return Center(child: Text(_error));
    } else if (_searchQueryController.text.isEmpty) {
      return Center(
          child: Text(AppLocalizations.of(context).searchEmptyHistory));
    } else if (_results.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context).searchEmpty));
    } else {
      return InfiniteScrollListWidget(
        LoadedData(_results, _total),
        (article) => ArticleItemWidget(article: article),
        (page) => loadMoreSearchItems(page),
      );
    }
  }

  Future<List<Article>> loadMoreSearchItems(int page) async {
    print("page:$page");
    var articlesResponse = await ArticlesDataSource.getAll(currentQuery, page);
    return articlesResponse.articles;
  }
}
