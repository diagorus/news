import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news/screens/search.dart';
import 'package:news/screens/top_articles.dart';

class MyHomePage extends StatefulWidget {

  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentPageIndex = 0;

  List<Widget> _pages = [
    TopArticlesWidget(),
    Center(
      child: Text("In progress"),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News"),
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
      body: _pages[_currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentPageIndex,
          onTap: (pageIndex) {
            setState(() {
              _currentPageIndex = pageIndex;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.show_chart), title: Text("Top")),
            BottomNavigationBarItem(
                icon: Icon(Icons.all_inclusive), title: Text("All")),
          ]),
    );
  }
}
