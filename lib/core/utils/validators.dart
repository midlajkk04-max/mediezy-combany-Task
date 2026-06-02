class Validators {
  Validators._();

  static String? required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? mobile(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return 'Mobile number is required';
    if (trimmed.length < 10) return 'Enter a valid mobile number';
    return null;
  }

  static String? email(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(trimmed)) {
      return 'Enter a valid email';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.trim().isEmpty) return 'Password is required';
    if (value.length < 4) return 'Password must be at least 4 characters';
    return null;
  }

  static String? date(String? value) {
    if (value == null || value.trim().isEmpty) return 'Date is required';
    return null;
  }
}
