import 'package:flutter/material.dart';
import 'package:signup/theme/theme.dart';

/// Rounded form field used by the login and sign up screens.
class AuthTextField extends StatelessWidget {
  const AuthTextField({
    Key? key,
    required this.controller,
    required this.label,
    this.hintText,
    this.validator,
    this.obscureText = false,
    this.onToggleObscure,
  }) : super(key: key);

  final TextEditingController controller;
  final String label;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final VoidCallback? onToggleObscure;

  static const _border = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    borderSide: BorderSide(width: 1, color: AppTheme.hintColor),
  );

  static const _focusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    borderSide: BorderSide(width: 1, color: AppTheme.secondaryColor),
  );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: const TextStyle(
        color: AppTheme.primaryTextColor,
        fontSize: 13,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        hintStyle: const TextStyle(
          color: AppTheme.hintColor,
          fontSize: 10,
          fontWeight: FontWeight.w400,
        ),
        labelStyle: const TextStyle(
          color: AppTheme.primaryColor,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        suffixIcon: onToggleObscure == null
            ? null
            : InkWell(
                onTap: onToggleObscure,
                child: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                ),
              ),
        border: _border,
        errorBorder: _border,
        enabledBorder: _border,
        focusedBorder: _focusedBorder,
      ),
    );
  }
}
