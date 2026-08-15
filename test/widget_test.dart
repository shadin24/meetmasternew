import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signup/main.dart';
import 'package:signup/screens/login.dart';
import 'package:signup/theme/theme.dart';

void main() {
  // The splash screen schedules a navigation timer that has to run before the
  // test finishes, otherwise the framework reports a pending timer.
  Future<void> settleSplashTimer(WidgetTester tester) async {
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
  }

  testWidgets('MyApp shows the splash screen first', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.text('Meet Master'), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);

    await settleSplashTimer(tester);
  });

  testWidgets('MyApp configures the app theme', (tester) async {
    await tester.pumpWidget(const MyApp());

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.title, 'Meet Master');
    expect(app.debugShowCheckedModeBanner, isFalse);
    expect(app.theme?.primaryColor, AppTheme.primaryColor);
    expect(app.theme?.colorScheme.primary, AppTheme.primaryColor);
    expect(app.theme?.colorScheme.secondary, AppTheme.secondaryColor);
    expect(app.theme?.iconTheme.color, AppTheme.primaryTextColor);

    await settleSplashTimer(tester);
  });

  testWidgets('the splash screen hands over to the login screen',
      (tester) async {
    await tester.pumpWidget(const MyApp());

    await settleSplashTimer(tester);

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(SplashScreen), findsNothing);
  });
}
