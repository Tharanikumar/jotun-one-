import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension SafeNavigationExtension on BuildContext {
  void safePop({String fallbackRoute = '/app/dashboard'}) {
    if (canPop()) {
      pop();
    } else {
      go(fallbackRoute);
    }
  }
}
