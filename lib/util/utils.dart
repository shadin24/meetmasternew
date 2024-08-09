class Utils {
  static bool isValidEmail(String email) {
    // Define a regular expression for email validation
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
    );

    // Check if the email matches the regular expression
    return emailRegex.hasMatch(email);
  }
}
