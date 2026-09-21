/// Shared form-field validators used across feature screens.
///
/// These enforce client-side presence/format checks only. Server business
/// rules remain authoritative and surface via [ValidationFailure] /
/// [BusinessRuleFailure].
abstract final class Validators {
  static final RegExp _email = RegExp(
    r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
  );

  /// Digits with optional leading `+` and 8–15 digits total (E.164-ish).
  static final RegExp _phone = RegExp(
    r'^\+?[0-9]{8,15}$',
  );

  static String? required(
    String? value, {
    String message = 'This field is required',
  }) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  static String? email(
    String? value, {
    String emptyMessage = 'Enter an email address',
    String invalidMessage = 'Enter a valid email address',
  }) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return emptyMessage;
    if (!_email.hasMatch(trimmed)) return invalidMessage;
    return null;
  }

  static String? phone(
    String? value, {
    String emptyMessage = 'Enter a phone number',
    String invalidMessage = 'Enter a valid phone number',
  }) {
    final trimmed = (value ?? '').replaceAll(RegExp(r'[\s()-]'), '');
    if (trimmed.isEmpty) return emptyMessage;
    if (!_phone.hasMatch(trimmed)) return invalidMessage;
    return null;
  }

  /// Accepts either an email or a phone identifier (login-style fields).
  static String? emailOrPhone(
    String? value, {
    String emptyMessage = 'Enter email or phone',
    String invalidMessage = 'Enter a valid email or phone',
  }) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return emptyMessage;
    final phoneCandidate = trimmed.replaceAll(RegExp(r'[\s()-]'), '');
    final okEmail = _email.hasMatch(trimmed);
    final okPhone = _phone.hasMatch(phoneCandidate);
    if (!okEmail && !okPhone) return invalidMessage;
    return null;
  }

  static String? minLength(
    String? value,
    int min, {
    String? message,
  }) {
    final text = value ?? '';
    if (text.length < min) {
      return message ?? 'Must be at least $min characters';
    }
    return null;
  }

  static String? password(
    String? value, {
    int minLength = 8,
    String emptyMessage = 'Enter a password',
    String? tooShortMessage,
  }) {
    if (value == null || value.isEmpty) return emptyMessage;
    if (value.length < minLength) {
      return tooShortMessage ?? 'Password must be at least $minLength characters';
    }
    return null;
  }

  /// Composes validators; returns the first non-null error.
  static String? Function(String?) compose(
    List<String? Function(String?)> validators,
  ) {
    return (value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) return error;
      }
      return null;
    };
  }
}
