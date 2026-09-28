import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/shell_strings.dart';
import '../router/routes.dart';

/// Shown by [GoRouter.errorBuilder] for unmatched paths.
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key, this.uri});

  final Uri? uri;

  @override
  Widget build(BuildContext context) {
    final location = uri?.toString() ?? '';
    return Scaffold(
      appBar: AppBar(title: const Text(ShellStrings.notFoundTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.explore_off_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(height: 16),
              Text(
                ShellStrings.notFoundMessage,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              if (location.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  location,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => context.go(Routes.splash),
                child: const Text(ShellStrings.notFoundGoHome),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
