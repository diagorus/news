import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news/model/simple_data_store.dart';
import 'package:news/screens/search.dart';
import 'package:news/screens/top_articles.dart';

import '../application.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String languageCode = '';

  @override
  void initState() {
    super.initState();

    restoreLanguageCode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Theme(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: languageCode,
              items: buildDropDownItems(),
              onChanged: (String value) {
                PreferencesManager().storeLanguageCode(value);
                setState(() {
                  languageCode = value;
                  application.onLocaleChanged(Locale(languageCode));
                });
              },
            ),
          ),
          data: ThemeData.dark(),
        ),
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
      body: TopArticlesWidget(ValueKey(languageCode), languageCode),
    );
  }

  List<DropdownMenuItem<String>> buildDropDownItems() {
    return languageCode.isEmpty ? [
      DropdownMenuItem(
        child: Text(''),
        value: '',
      ),
    ] :
    [
      DropdownMenuItem(
        child: Text('Українські новини'),
        value: 'uk',
      ),
      DropdownMenuItem(
        child: Text('English news'),
        value: 'en',
      ),
    ];
  }

  restoreLanguageCode() async {
    var restoredLanguageCode = await PreferencesManager()
        .restoreLanguageCode() ?? 'uk';
    setState(() {
      languageCode = restoredLanguageCode;
      application.onLocaleChanged(Locale(languageCode));
    });
  }
}
