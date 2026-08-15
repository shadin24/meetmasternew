import 'package:flutter/material.dart';
import 'package:signup/theme/theme.dart';

/// Outlined form field used by the meeting screens.
class AppTextField extends StatelessWidget {
  const AppTextField({
    Key? key,
    required this.controller,
    required this.label,
    this.validator,
    this.maxLines = 1,
    this.readOnly = false,
    this.suffixIcon,
  }) : super(key: key);

  final TextEditingController controller;
  final String label;
  final FormFieldValidator<String>? validator;
  final int maxLines;
  final bool readOnly;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        readOnly: readOnly,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppTheme.primaryColor),
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
