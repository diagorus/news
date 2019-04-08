import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:news/screens/register.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Вход"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 16),
            Text('Войти с помощью акаунта'),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton.icon(
                  icon: SvgPicture.asset(
                    'images/google.svg',
                    semanticsLabel: 'News logo',
                    height: 48,
                    color: Colors.white,
                  ),
                  label: Text('Google'),
                  onPressed: () {
                    //TODO: login google
                  },
                ),
                RaisedButton.icon(
                  icon: SvgPicture.asset(
                    'images/facebook.svg',
                    semanticsLabel: 'News logo',
                    height: 48,
                  ),
                  label: Text('Facebook'),
                  onPressed: () {
                    //TODO: login facebook
                  },
                )
              ],
            ),
            SizedBox(height: 16),
            Text('или'),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: "Эл. почта",
              ),
            ),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: "Пароль",
              ),
            ),
            SizedBox(height: 8),
            RaisedButton(
              child: Text('Войти'),
              onPressed: () {},
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                  child: Text('Забыли пароль?'),
                  onPressed: () {
                    //TODO: password recovery
                  },
                ),
                FlatButton(
                  child: Text('Регистрация'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
