import 'package:flutter/material.dart';

class Application {
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState.pushNamed(routeName);
  }
}
