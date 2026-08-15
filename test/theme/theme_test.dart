import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signup/constants.dart';
import 'package:signup/theme/theme.dart';

void main() {
  test('AppTheme exposes the brand palette', () {
    expect(AppTheme.primaryColor, const Color(0xFF755DC1));
    expect(AppTheme.secondaryColor, const Color(0xFF9F7BFF));
    expect(AppTheme.primaryTextColor, const Color(0xFF393939));
  });

  test('profileImage points at an https url', () {
    expect(Uri.parse(profileImage).scheme, 'https');
  });
}
