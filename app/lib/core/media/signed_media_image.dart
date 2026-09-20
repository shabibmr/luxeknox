import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../error/failures.dart';
import 'signed_media_resolver.dart';

/// Renders the image behind an object key by resolving a fresh signed GET
/// URL first (FR-MEDIA-003). Shows a spinner while resolving, a "no access"
/// message on [PermissionFailure] (403), and a generic broken-image state
/// for anything else — it never crashes the surrounding screen.
class SignedMediaImage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final resolver = this.resolver ?? GetIt.instance<SignedMediaResolver>();

    return FutureBuilder(
      future: resolver.resolve(objectKey),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return _StateBox(
            height: height,
            child: const CircularProgressIndicator(),
          );
        }

        final result = snapshot.data!;
        return result.fold(
          (failure) => _StateBox(
            height: height,
            child: Text(
              failure is PermissionFailure
                  ? 'No access to this image'
                  : 'Image unavailable',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          (url) => ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              url,
              height: height,
              fit: fit,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return _StateBox(
                  height: height,
                  child: const CircularProgressIndicator(),
                );
              },
              errorBuilder: (context, error, stackTrace) => _StateBox(
                height: height,
                child: const Icon(Icons.broken_image_outlined),
              ),
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
