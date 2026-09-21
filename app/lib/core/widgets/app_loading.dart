import 'package:flutter/material.dart';

/// Centered indeterminate progress indicator for full-screen or inline loads.
class AppLoading extends StatelessWidget {
  const AppLoading({super.key, this.message});

  /// Optional caption shown under the spinner.
  final String? message;

  @override
  Widget build(BuildContext context) {
    final caption = message;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            if (caption != null && caption.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                caption,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
