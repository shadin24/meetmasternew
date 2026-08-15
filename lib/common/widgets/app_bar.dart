import 'package:flutter/material.dart';
import 'package:signup/theme/theme.dart';

/// AppBar with the app's shared white background / primary coloured title.
class AppScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppScreenAppBar({
    Key? key,
    this.title,
    this.titleWidget,
    this.actions,
    this.elevation,
  }) : super(key: key);

  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final double? elevation;

  static const titleStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: AppTheme.primaryColor,
  );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: titleWidget ?? Text(title ?? '', style: titleStyle),
      backgroundColor: Colors.white,
      foregroundColor: AppTheme.primaryColor,
      elevation: elevation,
      actions: actions,
    );
  }
}
