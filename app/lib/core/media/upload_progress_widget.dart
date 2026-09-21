import 'package:flutter/material.dart';

/// Reusable widget for displaying upload progress, cancellation, and retry actions (FR-MEDIA-001/002).
class UploadProgressWidget extends StatelessWidget {
  const UploadProgressWidget({
    super.key,
    required this.isUploading,
    this.progress,
    this.sentBytes,
    this.totalBytes,
    this.errorMessage,
    this.onCancel,
    this.onRetry,
  });

  final bool isUploading;
  final double? progress;
  final int? sentBytes;
  final int? totalBytes;
  final String? errorMessage;
  final VoidCallback? onCancel;
  final VoidCallback? onRetry;

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    if (!isUploading && errorMessage == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.all(8),
      color: errorMessage != null
          ? colorScheme.errorContainer
          : colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isUploading) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Uploading…',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (progress != null)
                    Text(
                      '${(progress! * 100).toInt()}%',
                      style: theme.textTheme.labelMedium,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(value: progress),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (sentBytes != null && totalBytes != null)
                    Text(
                      '${_formatBytes(sentBytes!)} / ${_formatBytes(totalBytes!)}',
                      style: theme.textTheme.bodySmall,
                    )
                  else
                    const SizedBox.shrink(),
                  if (onCancel != null)
                    TextButton.icon(
                      onPressed: onCancel,
                      icon: const Icon(Icons.close, size: 16),
                      label: const Text('Cancel'),
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                ],
              ),
            ],
            if (errorMessage != null) ...[
              Row(
                children: [
                  Icon(Icons.error_outline, color: colorScheme.error, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      errorMessage!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.tonalIcon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('Retry'),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
