import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signup/screens/home/profile_screen.dart';
import 'package:signup/screens/login.dart';
import 'package:signup/screens/sign_up_screen.dart';

void main() {
  Future<void> pumpLogin(WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
    await tester.pumpAndSettle();
  }

  Finder emailField() => find.ancestor(
        of: find.text('Email'),
        matching: find.byType(TextFormField),
      );

  Finder passwordField() => find.ancestor(
        of: find.text('Password'),
        matching: find.byType(TextFormField),
      );

  testWidgets('renders the login form', (tester) async {
    await pumpLogin(tester);

    expect(find.text('Log In'), findsNWidgets(2)); // heading and button
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Don’t have an account?'), findsOneWidget);
    expect(find.text('Forgot Password?'), findsOneWidget);
  });

  testWidgets('reports an empty email and an invalid email', (tester) async {
    await pumpLogin(tester);

    await tester.enterText(emailField(), 'a');
    await tester.pumpAndSettle();
    expect(find.text('Enter Valid Email'), findsOneWidget);

    await tester.enterText(emailField(), '');
    await tester.pumpAndSettle();
    expect(find.text('Enter Email'), findsOneWidget);

    await tester.enterText(emailField(), 'user@example.com');
    await tester.pumpAndSettle();
    expect(find.text('Enter Valid Email'), findsNothing);
    expect(find.text('Enter Email'), findsNothing);
  });

  testWidgets('requires a password of at least 6 characters', (tester) async {
    await pumpLogin(tester);

    await tester.enterText(passwordField(), '12345');
    await tester.pumpAndSettle();
    expect(find.text('Enter valid 6 digit Password'), findsOneWidget);

    await tester.enterText(passwordField(), '123456');
    await tester.pumpAndSettle();
    expect(find.text('Enter valid 6 digit Password'), findsNothing);
  });

  testWidgets('toggles password visibility', (tester) async {
    await pumpLogin(tester);

    expect(find.byIcon(Icons.visibility_off), findsOneWidget);

    await tester.tap(find.byIcon(Icons.visibility_off));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.visibility), findsOneWidget);
    expect(find.byIcon(Icons.visibility_off), findsNothing);
  });

  testWidgets('stays on the login screen when the form is invalid',
      (tester) async {
    await pumpLogin(tester);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Log In'));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileScreen), findsNothing);
    expect(find.text('Enter Email'), findsOneWidget);
    expect(find.text('Enter valid 6 digit Password'), findsOneWidget);
  });

  testWidgets('opens the profile screen with the entered email on success',
      (tester) async {
    await pumpLogin(tester);

    await tester.enterText(emailField(), 'user@example.com');
    await tester.enterText(passwordField(), 'secret1');
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Log In'));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileScreen), findsOneWidget);
    expect(
      tester.widget<ProfileScreen>(find.byType(ProfileScreen)).email,
      'user@example.com',
    );
  });

  testWidgets('navigates to the sign up screen', (tester) async {
    await pumpLogin(tester);

    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();

    expect(find.byType(SingUpScreen), findsOneWidget);
  });
}
