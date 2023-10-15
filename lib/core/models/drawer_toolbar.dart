import 'package:flutter/foundation.dart';

class DrawerAndToolbar with ChangeNotifier {
  int _currentIndex = 0;
  String _title;
  bool _isDesktop;

  bool get isDesktop => _isDesktop;

  set isDesktop(bool value) {
    _isDesktop = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  int get currentIndex => _currentIndex;

  set currentIndex(int value) {
    _currentIndex = value;
    notifyListeners();
  }
}
