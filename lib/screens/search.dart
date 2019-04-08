import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:news/models.dart';
import 'package:news/screens/wigets/ArticleItemWidget.dart';

class SearchScreen extends StatefulWidget {
  @override
  State createState() => _SearchState();
}

class _SearchState extends State<SearchScreen> {
  final TextEditingController _searchQueryController = TextEditingController();

  bool _isSearching = false;
  String _error;
  List<Article> _results = List();

  Timer debounceTimer;

  _SearchState() {
    _searchQueryController.addListener(() {
//      if (debounceTimer != null) {
//        debounceTimer.cancel();
//      }
//      debounceTimer = Timer(Duration(milliseconds: 500), () {
        if (this.mounted) {
          _performSearch(_searchQueryController.text);
        }
//      });
    });
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
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            hintText: "Search articles...",
            hintStyle: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_isSearching) {
      return CenterTitle('Searching Github...');
    } else if (_error != null) {
      return CenterTitle(_error);
    } else if (_searchQueryController.text.isEmpty) {
      return CenterTitle('Begin Search by typing on search bar');
    } else {
      return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          itemCount: _results.length,
          itemBuilder: (BuildContext context, int index) {
            return ArticleItemWidget(article: _results[index]);
          });
    }
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

    final repos = await _fetchNews(query);
    if (this._searchQueryController.text == query && this.mounted) {
      setState(() {
        _isSearching = false;
        if (repos != null) {
          _results = repos;
        } else {
          _error = 'Error searching repos';
        }
      });
    }
  }

  Future<List<Article>> _fetchNews(String query) async {
    final response = await http.get(
        'https://newsapi.org/v2/everything?q=$query&apiKey=8c655aa98f4a488aa4dcafff411952d5');
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

class CenterTitle extends StatelessWidget {
  final String title;

  CenterTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        alignment: Alignment.center,
        child: Text(
          title,
          style: Theme.of(context).textTheme.headline,
          textAlign: TextAlign.center,
        ));
  }
}
