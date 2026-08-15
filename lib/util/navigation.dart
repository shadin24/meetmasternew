import 'package:flutter/material.dart';

Future<T?> pushScreen<T>(BuildContext context, Widget screen) {
  return Navigator.push<T>(
    context,
    MaterialPageRoute(builder: (context) => screen),
  );
}

Future<T?> replaceScreen<T>(BuildContext context, Widget screen) {
  return Navigator.of(context).pushReplacement<T, void>(
    MaterialPageRoute(builder: (context) => screen),
  );
}
