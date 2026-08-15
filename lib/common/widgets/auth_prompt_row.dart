import 'package:flutter/material.dart';
import 'package:signup/theme/theme.dart';

/// "Don't have an account? Sign Up" style row shared by the auth screens.
class AuthPromptRow extends StatelessWidget {
  const AuthPromptRow({
    Key? key,
    required this.question,
    required this.actionLabel,
    required this.onActionTap,
  }) : super(key: key);

  final String question;
  final String actionLabel;
  final VoidCallback onActionTap;

  static const _textStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          question,
          style: _textStyle.copyWith(color: AppTheme.hintColor),
        ),
        const SizedBox(width: 2.5),
        InkWell(
          onTap: onActionTap,
          child: Text(
            actionLabel,
            style: _textStyle.copyWith(color: AppTheme.primaryColor),
          ),
        ),
      ],
    );
  }
}
