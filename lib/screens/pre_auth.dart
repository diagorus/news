import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:news/screens/home.dart';
import 'package:news/screens/login.dart';

class PreAuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            SvgPicture.asset(
              'images/seven-news.svg',
              semanticsLabel: 'News logo',
              height: 500,
            ),
            RaisedButton(
              child: Text('Войти / Зарегистрироваться'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
            ),
            FlatButton(
              child: Text('Продолжить'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
