import 'package:flutter/material.dart';
import 'package:news/screens/login.dart';
import 'package:news/screens/pre_auth.dart';
import 'package:news/screens/register.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
//      home: MyHomePage(title: 'News'),
    home: PreAuthScreen(),
    );
  }
}
