import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signup/common/widgets/common_button.dart';
import 'package:signup/theme/theme.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('renders its label sized to the requested box', (tester) async {
    await tester.pumpWidget(wrap(CommonButton(
      label: 'Log In',
      onPressed: () {},
      height: 50,
      width: 200,
    )));

    expect(find.text('Log In'), findsOneWidget);

    final box = tester.widget<SizedBox>(find.ancestor(
      of: find.byType(ElevatedButton),
      matching: find.byType(SizedBox),
    ));
    expect(box.height, 50);
    expect(box.width, 200);
  });

  testWidgets('uses the primary color as its background', (tester) async {
    await tester.pumpWidget(wrap(CommonButton(
      label: 'Log In',
      onPressed: () {},
      height: 50,
      width: 200,
    )));

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    final background = button.style!.backgroundColor!.resolve({});
    expect(background, AppTheme.primaryColor);
  });

  testWidgets('invokes onPressed once per tap', (tester) async {
    var taps = 0;
    await tester.pumpWidget(wrap(CommonButton(
      label: 'Create account',
      onPressed: () => taps++,
      height: 50,
      width: 200,
    )));

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(taps, 1);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(taps, 2);
  });
}
