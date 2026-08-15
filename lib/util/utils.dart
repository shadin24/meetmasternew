class Utils {
  static bool isValidEmail(String email) {
    // Define a regular expression for email validation
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.[a-zA-Z]{2,}$',
    );

    // Check if the email matches the regular expression
    return emailRegex.hasMatch(email);
  }

  static const int minPasswordLength = 8;

  /// Returns an error message, or null when [password] is acceptable.
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Enter Password';
    }
    if (password.length < minPasswordLength) {
      return 'Password must be at least $minPasswordLength characters';
    }
    if (!password.contains(RegExp(r'[A-Za-z]')) ||
        !password.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain letters and numbers';
    }
    return null;
  }
}
