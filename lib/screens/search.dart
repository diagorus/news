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

    loadHistory();
  }

  @override
  void dispose() {
    _searchQueryController.removeListener(_onSearchChanged);
    _searchQueryController.dispose();
    super.dispose();
  }

  _onSearchChanged() {
    if (debounceTimer?.isActive ?? false) {
      debounceTimer.cancel();
    }
    debounceTimer = Timer(Duration(milliseconds: 1000), () {
      if (this.mounted) {
        var newQuery = _searchQueryController.text;
        if (newQuery.isEmpty) {
          loadHistory();
        } else {
          if (currentQuery != newQuery) {
            currentQuery = newQuery;
            _performSearch(newQuery);
          }
        }
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
      await DBProvider.db
          .insertOrReplaceSearchHistory(SearchHistory(timestamp, query));

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
            suffixIcon: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.white,
              ),
              onPressed: () {
                _searchQueryController.clear();
              },
            ),
          ),
        ),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (currentQuery.isEmpty) {
      return buildSearchHistory();
    } else {
      return _buildResultsBody(context);
    }
  }

  Widget _buildResultsBody(BuildContext context) {
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
      return buildSearchHistory();
    } else if (_results.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context).searchEmpty));
    } else {
      return InfiniteScrollListWidget(
        key: Key(currentQuery),
        initialItems: LoadedData(_results, _total),
        onCreateItem: (article) => ArticleItemWidget(article),
        onLoadMore: (page) => loadMoreSearchItems(page),
      );
    }
  }

  Future<List<Article>> loadMoreSearchItems(int page) async {
    print("page:$page");
    var articlesResponse = await ArticlesDataSource.getAll(currentQuery, page);
    return articlesResponse.articles;
  }

  var isHistoryLoading = false;
  List<SearchHistory> searchHistory = [];

  Widget buildSearchHistory() {
    if (isHistoryLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (searchHistory.isEmpty) {
      return Center(
          child: Text(AppLocalizations
              .of(context)
              .searchEmptyHistory));
    } else {
      return ListView.builder(
        itemCount: searchHistory.length,
        itemBuilder: (context, index) {
          var currentSearchHistory = searchHistory[index];
          return Dismissible(
            background: Container(
              color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(AppLocalizations
                        .of(context)
                        .searchRemove,
                        style: TextStyle(color: Colors.white)),
                    Icon(Icons.delete, color: Colors.white)
                  ],
                ),
              ),
            ),
            key: Key(currentSearchHistory.query),
            onDismissed: (direction) {
              setState(() {
                DBProvider.db.deleteSearchHistory(currentSearchHistory);
                searchHistory.removeAt(index);
              });

              Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(AppLocalizations
                      .of(context)
                      .searchRemoved)));
            },
            child: InkWell(
              onTap: () {
                setSearch(currentSearchHistory);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.history,
                      color: Colors.grey[500],
                    ),
                    Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(currentSearchHistory.query),
                        )),
                    InkWell(
                      child: Icon(
                        Icons.call_made,
                        color: Colors.grey[600],
                      ),
                      onTap: () {
                        setSearch(currentSearchHistory);
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }

  setSearch(SearchHistory currentSearchHistory) {
    _searchQueryController.text = currentSearchHistory.query;
    _searchQueryController.selection = TextSelection.fromPosition(
        TextPosition(offset: _searchQueryController.text.length));
  }

  loadHistory() async {
    setState(() {
      isHistoryLoading = true;
      searchHistory = List();
    });

    var searchHistoryData =
        await DBProvider.db.getAllSearchHistoryOrdered() ?? [];
    setState(() {
      isHistoryLoading = false;
      searchHistory = searchHistoryData;
    });
  }
}
