import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:mobiwoom/core/utils/shared_pref_util.dart';


class AppLanguage extends ChangeNotifier {
  Locale _appLocale = Locale('fr');

  Locale get appLocal => _appLocale ?? Locale('fr');

  fetchLocale() async {
    if (SharedPrefUtil.getUserLanguage() == null) {
      _appLocale = Locale('fr');
      return Null;
    }
    _appLocale = Locale(SharedPrefUtil.getUserLanguage());
  //  _appLocale = Locale('fr');
    return Null;
  }

  Future<void> changeLanguage(Locale type) async {
    if (_appLocale == type) {
      return;
    }

    if (type == Locale('fr')) {
      _appLocale = Locale('fr');
      await SharedPrefUtil.setUserLanguage('fr');
      await SharedPrefUtil.setUserCountryCode('FR');
    } else if (type == Locale('gb')) {
      _appLocale = Locale('en');
      await SharedPrefUtil.setUserLanguage('gb');
      await SharedPrefUtil.setUserCountryCode('GB');
    } else if (type == Locale('lu')) {
      _appLocale = Locale('fr','LU');
      await SharedPrefUtil.setUserLanguage('lu');
      await SharedPrefUtil.setUserCountryCode('LU');
    } else if (type == Locale('de')) {
      _appLocale = Locale('de');
      await SharedPrefUtil.setUserLanguage('de');
      await SharedPrefUtil.setUserCountryCode('DE');
    } else if (type == Locale('be')) {
      _appLocale = Locale('be');
      await SharedPrefUtil.setUserLanguage('be');
      await SharedPrefUtil.setUserCountryCode('BE');
    } else {
      _appLocale = Locale('fr');
      await SharedPrefUtil.setUserLanguage('fr');
      await SharedPrefUtil.setUserCountryCode('FR');
    }
    notifyListeners();
  }
}
