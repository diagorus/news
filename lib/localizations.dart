import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'application.dart';

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
      'searchRemove': 'Видалити',
      'searchRemoved': 'Видалено',
      'open': 'Відкрити'
    },
    'en': {
      'appTitle': 'News',
      'searchError': 'Search error',
      'searchHint': 'Search articles...',
      'searchProgress': 'Searching, wait a bit...',
      'searchEmptyHistory': 'Search history empty',
      'searchEmpty': 'Nothing found :(',
      'searchRemove': 'Remove',
      'searchRemoved': 'Removed',
      'open': 'Open'
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

  String get searchRemove =>
      _localizedValues[locale.languageCode]['searchRemove'];

  String get searchRemoved =>
      _localizedValues[locale.languageCode]['searchRemoved'];

  String get open => _localizedValues[locale.languageCode]['open'];
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  final Locale newLocale;

  const AppLocalizationsDelegate({this.newLocale});

  @override
  bool isSupported(Locale locale) =>
      application.supportedLanguagesCodes.contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(
        AppLocalizations(newLocale ?? locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => true;
}
