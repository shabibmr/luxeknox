import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:get_it/get_it.dart';

import '../error/failures.dart';
import 'signed_media_resolver.dart';

/// Renders the image behind an object key by resolving a fresh signed GET
/// URL first (FR-MEDIA-003). Shows a spinner while resolving, a "no access"
/// message on [PermissionFailure] (403), and a generic broken-image state
/// for anything else — it never crashes the surrounding screen.
class SignedMediaImage extends StatefulWidget {
  const SignedMediaImage({
    super.key,
    required this.objectKey,
    this.height,
    this.fit = BoxFit.cover,
    this.resolver,
  });

  final String objectKey;
  final double? height;
  final BoxFit fit;

  /// Injectable for tests; defaults to the DI-registered resolver.
  final SignedMediaResolver? resolver;

  @override
  State<SignedMediaImage> createState() => _SignedMediaImageState();
}

class _SignedMediaImageState extends State<SignedMediaImage> {
  late Future<Either<Failure, String>> _future;
  bool _hasAttemptedRecovery = false;

  SignedMediaResolver get _resolver =>
      widget.resolver ?? GetIt.instance<SignedMediaResolver>();

  @override
  void initState() {
    super.initState();
    _future = _resolver.resolve(widget.objectKey);
  }

  @override
  void didUpdateWidget(SignedMediaImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.objectKey != widget.objectKey) {
      _hasAttemptedRecovery = false;
      _future = _resolver.resolve(widget.objectKey);
    }
  }

  void _retry({bool forceRefresh = false}) {
    setState(() {
      _future = _resolver.resolve(
        widget.objectKey,
        forceRefresh: forceRefresh,
      );
    });
  }

  void _onImageLoadError() {
    // If image failed to load, it might have been an expired presigned URL.
    // Automatically trigger expired URL recovery once.
    if (!_hasAttemptedRecovery && mounted) {
      _hasAttemptedRecovery = true;
      _retry(forceRefresh: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return _StateBox(
            height: widget.height,
            child: const CircularProgressIndicator(),
          );
        }

        final result = snapshot.data!;
        return result.fold(
          (failure) => _StateBox(
            height: widget.height,
            child: InkWell(
              onTap: () => _retry(forceRefresh: true),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  failure is PermissionFailure
                      ? 'No access to this image'
                      : 'Image unavailable (tap to retry)',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          ),
          (url) => ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              url,
              height: widget.height,
              fit: widget.fit,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return _StateBox(
                  height: widget.height,
                  child: const CircularProgressIndicator(),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                _onImageLoadError();
                return _StateBox(
                  height: widget.height,
                  child: InkWell(
                    onTap: () => _retry(forceRefresh: true),
                    child: const Icon(Icons.broken_image_outlined),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _StateBox extends StatelessWidget {
  const _StateBox({required this.height, required this.child});

  final double? height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}
