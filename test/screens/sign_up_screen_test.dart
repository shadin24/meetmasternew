import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signup/screens/login.dart';
import 'package:signup/screens/sign_up_screen.dart';

void main() {
  Future<void> pumpSignUp(WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SingUpScreen()));
    await tester.pumpAndSettle();
  }

  Finder fieldLabelled(String label) => find.ancestor(
        of: find.text(label),
        matching: find.byType(TextFormField),
      );

  Future<void> tapVisible(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  testWidgets('renders the sign up form', (tester) async {
    await pumpSignUp(tester);

    expect(find.text('Sign up'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Confirm Password'), findsWidgets);
    expect(find.widgetWithText(ElevatedButton, 'Create account'),
        findsOneWidget);
  });

  testWidgets('validates the email field', (tester) async {
    await pumpSignUp(tester);

    await tester.enterText(fieldLabelled('Email'), 'not-an-email');
    await tester.pumpAndSettle();
    expect(find.text('Enter Valid Email'), findsOneWidget);

    await tester.enterText(fieldLabelled('Email'), '');
    await tester.pumpAndSettle();
    expect(find.text('Enter Email'), findsOneWidget);
  });

  testWidgets('requires the confirmation to match the password',
      (tester) async {
    await pumpSignUp(tester);

    await tester.enterText(fieldLabelled('Password'), 'secret1');
    await tester.enterText(fieldLabelled('Confirm Password'), 'secret2');
    await tester.pumpAndSettle();
    expect(find.text('Password does not match'), findsOneWidget);

    await tester.enterText(fieldLabelled('Confirm Password'), 'secret1');
    await tester.pumpAndSettle();
    expect(find.text('Password does not match'), findsNothing);
  });

  testWidgets('toggles both password fields independently', (tester) async {
    await pumpSignUp(tester);

    expect(find.byIcon(Icons.visibility_off), findsNWidgets(2));

    await tapVisible(tester, find.byIcon(Icons.visibility_off).first);
    expect(find.byIcon(Icons.visibility), findsOneWidget);
    expect(find.byIcon(Icons.visibility_off), findsOneWidget);

    await tapVisible(tester, find.byIcon(Icons.visibility_off));
    expect(find.byIcon(Icons.visibility), findsNWidgets(2));
  });

  testWidgets('stays put when the form is invalid', (tester) async {
    await pumpSignUp(tester);

    await tapVisible(
        tester, find.widgetWithText(ElevatedButton, 'Create account'));

    expect(find.byType(LoginScreen), findsNothing);
    expect(find.text('Enter Email'), findsOneWidget);
  });

  testWidgets('goes to the login screen once the form is valid',
      (tester) async {
    await pumpSignUp(tester);

    await tester.enterText(fieldLabelled('Email'), 'user@example.com');
    await tester.enterText(fieldLabelled('Password'), 'secret1');
    await tester.enterText(fieldLabelled('Confirm Password'), 'secret1');
    await tester.pumpAndSettle();

    await tapVisible(
        tester, find.widgetWithText(ElevatedButton, 'Create account'));

    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('the log in link opens the login screen', (tester) async {
    await pumpSignUp(tester);

    await tapVisible(tester, find.text('Log In '));

    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
