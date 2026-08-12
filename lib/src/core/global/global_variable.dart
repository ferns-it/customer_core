import 'package:customer_core/src/core/routes/routes.dart';
import 'package:flutter/material.dart';

class GlobalVariable {
  static GlobalKey<NavigatorState> globalKey = GlobalKey<NavigatorState>();
  static BuildContext? get context => globalKey.currentState?.context;
  static AppRouter? router;
}
