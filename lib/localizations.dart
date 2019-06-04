import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'uk': {
      'appTitle': 'Новини',
      'searchError': 'Помилка пошуку',
      'searchHint': 'Пошук статей...',
      'searchProgress': 'Йде пошук, зачекайте, будь-ласка...',
      'searchEmptyHistory': 'Немає історії пошуку',
      'searchEmpty': 'Нічого не знайдено :(',
    },
    'ru': {
      'appTitle': 'Новости',
      'searchError': 'Ошибка поиска',
      'searchHint': 'Поиск новостей...',
      'searchProgress': 'Поиск, подождите, пожалуйста...',
      'searchEmptyHistory': 'Нет истории поиска',
      'searchEmpty': 'Ничего не найдено :(',
    },
    'en': {
      'appTitle': 'News',
      'searchError': 'Search error',
      'searchHint': 'Search articles...',
      'searchProgress': 'Searching, wait a bit...',
      'searchEmptyHistory': 'Search history empty',
      'searchEmpty': 'Nothing found :(',
    },
  };

  String get appTitle => _localizedValues[locale.languageCode]['appTitle'];

  String get searchError =>
      _localizedValues[locale.languageCode]['searchError'];

  String get searchHint => _localizedValues[locale.languageCode]['searchHint'];

  String get searchProgress =>
      _localizedValues[locale.languageCode]['searchProgress'];

  String get searchEmptyHistory =>
      _localizedValues[locale.languageCode]['searchEmptyHistory'];

  String get searchEmpty =>
      _localizedValues[locale.languageCode]['searchEmpty'];
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['uk', 'ru', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
