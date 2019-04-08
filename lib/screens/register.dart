import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Регистрация"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                hintText: "Имя",
              ),
            ),
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
            Text(
                'Пароль должен быть не менее 6 символов, содержать цифры и заглавные буквы и не должен совпадать с именем и эл. почтой'),
            SizedBox(height: 8),
            RaisedButton(
              child: Text('Зарегистрироваться'),
              onPressed: () {},
            ),
            Text('Регистрируясь, вы соглашаетесь с'),
            Text(
              'пользовательским соглашением',
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            )
          ],
        ),
      ),
    );
  }
}
