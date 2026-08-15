import 'package:flutter/material.dart';
import 'package:signup/theme/theme.dart';

/// Stadium shaped primary button used by the meeting forms.
class PillButton extends StatelessWidget {
  const PillButton({
    Key? key,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryColor,
        shape: const StadiumBorder(),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
