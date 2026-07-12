import 'package:flutter/material.dart';

import '../locale/app_locale.dart';

extension LocaleContext on BuildContext {
  Locale get appLocale => Localizations.localeOf(this);

  String get dateFormatLocale => AppLocale.dateFormatLocale(appLocale);

  bool get isTurkish => appLocale.languageCode == 'tr';
}
