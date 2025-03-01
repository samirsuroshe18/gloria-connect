import 'package:flutter/material.dart';

class RouteObserverWithStack extends NavigatorObserver {
  final List<Route<dynamic>> routeStack = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    routeStack.add(route);
    print('Stack after push: ${routeStack.map((r) => r.settings.name).toList()}');
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    routeStack.remove(route);
    print('Stack after pop: ${routeStack.map((r) => r.settings.name).toList()}');
    super.didPop(route, previousRoute);
  }
}