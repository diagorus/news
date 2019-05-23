import 'package:flutter/material.dart';
import 'package:news/screens/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Новини',
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.purple[800],
          accentColor: Colors.cyan[600],
          fontFamily: 'Montserrat',
          textTheme: TextTheme(
            headline: TextStyle(fontSize: 72.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
            title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          )),
//      home: MyHomePage(title: 'News'),
      home: HomePage(),
    );
  }
}
