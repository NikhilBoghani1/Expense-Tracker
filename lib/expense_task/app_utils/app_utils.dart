class AppUtil {
  static String? isValidEmail(String email) {
    if (email.isEmpty) {
      return 'Email cannot be empty';
    }

    String p = r'^[^@]+@[^@]+\.[^@]+';
    RegExp regExp = RegExp(p);

    if (!regExp.hasMatch(email)) {
      return 'Invalid email address';
    }

    return null;
  }

  static String? isValidPassword(String password) {
    if (password.isEmpty) {
      return 'Password cannot be empty';
    }

    if (password.length < 6) {
      return 'Password must be at least 6 characters long';
    }

    return null;
  }

  static String? isValidConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return 'Confirm password cannot be empty';
    }

    if (password != confirmPassword) {
      return 'Passwords do not match';
    }

    return null;
  }
}
