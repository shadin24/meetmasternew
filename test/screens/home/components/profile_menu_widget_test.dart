import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signup/screens/home/components/profile_menu_widget.dart';
import 'package:signup/theme/theme.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('shows the title, leading icon and trailing chevron',
      (tester) async {
    await tester.pumpWidget(wrap(ProfileMenuWidget(
      title: 'My Meetings',
      icon: Icons.calendar_today,
      onPress: () {},
    )));

    expect(find.text('My Meetings'), findsOneWidget);
    expect(find.byIcon(Icons.calendar_today), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right), findsOneWidget);

    final icon = tester.widget<Icon>(find.byIcon(Icons.calendar_today));
    expect(icon.color, AppTheme.primaryColor);
  });

  testWidgets('hides the trailing chevron when endIcon is false',
      (tester) async {
    await tester.pumpWidget(wrap(ProfileMenuWidget(
      title: 'Logout',
      icon: Icons.power_settings_new,
      endIcon: false,
      onPress: () {},
    )));

    expect(find.byIcon(Icons.chevron_right), findsNothing);
    expect(tester.widget<ListTile>(find.byType(ListTile)).trailing, isNull);
  });

  testWidgets('applies textColor to the title', (tester) async {
    await tester.pumpWidget(wrap(ProfileMenuWidget(
      title: 'Logout',
      icon: Icons.power_settings_new,
      textColor: Colors.red,
      onPress: () {},
    )));

    final title = tester.widget<Text>(find.text('Logout'));
    expect(title.style?.color, Colors.red);
  });

  testWidgets('calls onPress when tapped', (tester) async {
    var pressed = 0;
    await tester.pumpWidget(wrap(ProfileMenuWidget(
      title: 'Search Meetings',
      icon: Icons.search,
      onPress: () => pressed++,
    )));

    await tester.tap(find.byType(ListTile));
    await tester.pump();

    expect(pressed, 1);
  });
}
