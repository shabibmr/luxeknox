import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';

import '../error/failures.dart';
import 'signed_media_resolver.dart';

/// Tappable link that resolves a fresh signed GET URL for [objectKey]
/// (FR-MEDIA-003) and opens it externally. Non-image documents (PDFs,
/// waivers) are never rendered in-app — mirrors `ExerciseMedia`'s
/// external-open pattern for video.
class SignedFileLink extends StatefulWidget {
  const SignedFileLink({
    super.key,
    required this.objectKey,
    required this.label,
    this.resolver,
    Future<bool> Function(Uri url)? launcher,
  }) : _launcher = launcher ?? _defaultLauncher;

  final String objectKey;
  final String label;

  /// Injectable for tests; defaults to the DI-registered resolver.
  final SignedMediaResolver? resolver;
  final Future<bool> Function(Uri url) _launcher;

  static Future<bool> _defaultLauncher(Uri url) =>
      launchUrl(url, mode: LaunchMode.externalApplication);

  @override
  State<SignedFileLink> createState() => _SignedFileLinkState();
}

class _SignedFileLinkState extends State<SignedFileLink> {
  bool _busy = false;
  String? _error;

  Future<void> _open({bool forceRefresh = false}) async {
    final resolver = widget.resolver ?? GetIt.instance<SignedMediaResolver>();
    setState(() {
      _busy = true;
      _error = null;
    });

    final result = await resolver.resolve(
      widget.objectKey,
      forceRefresh: forceRefresh,
    );
    if (!mounted) return;

    await result.fold(
      (failure) async {
        setState(() {
          _busy = false;
          _error = failure is PermissionFailure
              ? 'No access to this file'
              : 'File unavailable';
        });
      },
      (url) async {
        final launched = await widget._launcher(Uri.parse(url));
        if (!mounted) return;
        setState(() {
          _busy = false;
          _error = launched ? null : 'Could not open file';
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return TextButton.icon(
        onPressed: () => _open(forceRefresh: true),
        icon: const Icon(Icons.refresh, size: 16),
        label: Text(
          '$_error — Tap to retry',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      );
    }

    return OutlinedButton.icon(
      onPressed: _busy ? null : () => _open(),
      icon: _busy
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.description_outlined),
      label: Text(widget.label),
    );
  }
}
