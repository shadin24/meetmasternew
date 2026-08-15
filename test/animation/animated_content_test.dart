import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signup/animation/animated_content.dart';
import 'package:signup/theme/theme.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  group('AnimatedContent', () {
    double opacityOf(WidgetTester tester) => tester
        .widget<FadeTransition>(find
            .descendant(
              of: find.byType(AnimatedContent),
              matching: find.byType(FadeTransition),
            )
            .first)
        .opacity
        .value;

    Offset offsetOf(WidgetTester tester) => tester
        .widget<SlideTransition>(find
            .descendant(
              of: find.byType(AnimatedContent),
              matching: find.byType(SlideTransition),
            )
            .first)
        .position
        .value;

    testWidgets('starts hidden and offset when show is false', (tester) async {
      await tester.pumpWidget(wrap(const AnimatedContent(
        show: false,
        leftToRight: 0.0,
        topToBottom: 2.0,
        child: Text('hello'),
      )));

      expect(opacityOf(tester), 0.0);
      expect(offsetOf(tester), const Offset(0.0, 2.0));

      await tester.pump(const Duration(seconds: 1));
      expect(opacityOf(tester), 0.0);
    });

    testWidgets('animates to fully visible at rest when show is true',
        (tester) async {
      await tester.pumpWidget(wrap(const AnimatedContent(
        show: true,
        leftToRight: -1.0,
        topToBottom: 0.0,
        time: 400,
        child: Text('hello'),
      )));

      expect(opacityOf(tester), 0.0);

      await tester.pump(const Duration(milliseconds: 200));
      expect(opacityOf(tester), greaterThan(0.0));
      expect(opacityOf(tester), lessThan(1.0));

      await tester.pumpAndSettle();
      expect(opacityOf(tester), 1.0);
      expect(offsetOf(tester), Offset.zero);
      expect(find.text('hello'), findsOneWidget);
    });

    testWidgets('runs forward when show flips to true', (tester) async {
      Widget build(bool show) => wrap(AnimatedContent(
            show: show,
            topToBottom: 1.0,
            time: 400,
            child: const Text('hello'),
          ));

      await tester.pumpWidget(build(false));
      await tester.pumpAndSettle();
      expect(opacityOf(tester), 0.0);

      await tester.pumpWidget(build(true));
      await tester.pumpAndSettle();
      expect(opacityOf(tester), 1.0);
      expect(offsetOf(tester), Offset.zero);
    });

    testWidgets('reverses when show flips back to false', (tester) async {
      Widget build(bool show) => wrap(AnimatedContent(
            show: show,
            topToBottom: 1.0,
            time: 400,
            child: const Text('hello'),
          ));

      await tester.pumpWidget(build(true));
      await tester.pumpAndSettle();

      await tester.pumpWidget(build(false));
      await tester.pumpAndSettle();

      expect(opacityOf(tester), 0.0);
      expect(offsetOf(tester), const Offset(0.0, 1.0));
    });
  });

  group('AnimatedTextField', () {
    testWidgets('shows the label and writes input to the controller',
        (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
          wrap(AnimatedTextField(controller: controller, label: 'Email')));

      expect(find.text('Email'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), 'user@example.com');
      expect(controller.text, 'user@example.com');
    });

    testWidgets('highlights its border while focused', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
          wrap(AnimatedTextField(controller: controller, label: 'Email')));

      Border borderOf() {
        final container =
            tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
        return (container.decoration as BoxDecoration).border as Border;
      }

      expect(borderOf().top.color, Colors.grey);

      await tester.tap(find.byType(TextFormField));
      await tester.pumpAndSettle();
      expect(borderOf().top.color, AppTheme.primaryColor);

      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(borderOf().top.color, Colors.grey);
    });
  });

  group('AnimatedButton', () {
    testWidgets('renders its label and forwards taps', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
          wrap(AnimatedButton(onPressed: () => taps++, label: 'Submit')));

      expect(find.text('Submit'), findsOneWidget);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(taps, 1);
    });
  });
}
