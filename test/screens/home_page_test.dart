import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signup/screens/home_page.dart';

void main() {
  testWidgets('shows the Home title and body', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    expect(find.widgetWithText(AppBar, 'Home'), findsOneWidget);
    expect(find.text('Home Page'), findsOneWidget);
    expect(tester.widget<AppBar>(find.byType(AppBar)).elevation, 0);
  });
}
