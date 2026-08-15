import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signup/screens/home/components/profile_menu_widget.dart';
import 'package:signup/screens/home/profile_screen.dart';
import 'package:signup/screens/login.dart';

void main() {
  Future<void> pumpProfile(WidgetTester tester,
      {String email = 'user@example.com'}) async {
    await tester.pumpWidget(MaterialApp(home: ProfileScreen(email: email)));
    await tester.pumpAndSettle();
  }

  testWidgets('shows the signed in email and the avatar', (tester) async {
    await pumpProfile(tester, email: 'someone@example.com');

    expect(find.text('HOME'), findsOneWidget);
    expect(find.text('someone@example.com'), findsOneWidget);
    expect(find.byType(CircleAvatar), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);
  });

  testWidgets('lists every menu entry', (tester) async {
    await pumpProfile(tester);

    expect(find.byType(ProfileMenuWidget), findsNWidgets(4));
    expect(find.text('Create Meetings'), findsOneWidget);
    expect(find.text('My Meetings'), findsOneWidget);
    expect(find.text('Search Meetings'), findsOneWidget);
    expect(find.text('Logout'), findsNWidgets(2)); // app bar and menu entry
  });

  testWidgets('the logout menu entry has no trailing chevron and is red',
      (tester) async {
    await pumpProfile(tester);

    final logoutEntry = tester.widget<ProfileMenuWidget>(
        find.widgetWithText(ProfileMenuWidget, 'Logout'));
    expect(logoutEntry.endIcon, isFalse);
    expect(logoutEntry.textColor, Colors.red);
  });

  testWidgets('the app bar logout action returns to the login screen',
      (tester) async {
    await pumpProfile(tester);

    await tester.tap(find.byIcon(Icons.power_settings_new).first);
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('the logout menu entry returns to the login screen',
      (tester) async {
    await pumpProfile(tester);

    await tester.tap(find.widgetWithText(ProfileMenuWidget, 'Logout'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
