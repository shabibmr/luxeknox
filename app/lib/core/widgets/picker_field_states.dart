import 'package:flutter/material.dart';

/// Compact loading placeholder for a form field that loads its options
/// asynchronously (e.g. [DropdownButtonFormField] backed by an API call).
class PickerFieldSkeleton extends StatelessWidget {
  const PickerFieldSkeleton({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: const Padding(
          padding: EdgeInsets.all(12),
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      child: const Text(''),
    );
  }
}

/// Compact inline error state with tap-to-retry for an async-loaded field.
class PickerFieldRetry extends StatelessWidget {
  const PickerFieldRetry({
    super.key,
    required this.label,
    required this.message,
    required this.onRetry,
  });

  final String label;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onRetry,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.refresh),
        ),
        child: Text(message),
      ),
    );
  }
}
