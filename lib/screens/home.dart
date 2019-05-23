import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news/screens/search.dart';
import 'package:news/screens/top_articles.dart';

import 'all_articles.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPageIndex = 0;

  List<Widget> _pages = [
    TopArticlesWidget(),
    AllArticlesWidget(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Новини"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchScreen(),
                ),
              );
            },
          )
        ],
      ),
      body: TopArticlesWidget(),
    );
  }
}
