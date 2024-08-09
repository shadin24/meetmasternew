import 'package:flutter/material.dart';
import 'package:signup/theme/theme.dart';

class CommonButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double height;
  final double width;

  CommonButton(
      {required this.label,
      required this.onPressed,
      required this.height,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          onPressed: () {
            onPressed();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
