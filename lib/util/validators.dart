import 'package:signup/util/utils.dart';

class Validators {
  static String? required(String? value, String label) {
    if (value == null || value.isEmpty) {
      return 'Please enter $label';
    }
    return null;
  }

  static String? selection(String? value, String label) {
    if (value == null || value.isEmpty) {
      return 'Please select a $label';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter Email';
    }
    if (!Utils.isValidEmail(value)) {
      return 'Enter Valid Email';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.length < 6) {
      return 'Enter valid 6 digit Password';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Enter Password';
    }
    if (value != password) {
      return 'Password does not match';
    }
    return null;
  }
}
