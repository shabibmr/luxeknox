import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Shows the exercise's gif preview and/or a link to its video.
///
/// Per ADR-0005, video/gif are external URLs an admin pastes — never
/// uploaded media. Video is never played in-app (avoids guessing between a
/// YouTube link and a raw `.mp4`, an open gap the task register flags):
/// it always opens externally via [url_launcher]. The gif renders inline
/// since [Image.network] displays it directly regardless of host.
class ExerciseMedia extends StatelessWidget {
  const ExerciseMedia({
    super.key,
    this.videoUrl,
    this.gifUrl,
    Future<bool> Function(Uri url)? launcher,
  }) : _launcher = launcher ?? _defaultLauncher;

  final String? videoUrl;
  final String? gifUrl;

  /// Injectable so widget tests never trigger a real OS launch (url_launcher
  /// has no platform channel to mock on desktop; it would open a real
  /// browser during `flutter test`). Defaults to the real [launchUrl].
  final Future<bool> Function(Uri url) _launcher;

  static Future<bool> _defaultLauncher(Uri url) =>
      launchUrl(url, mode: LaunchMode.externalApplication);

  Future<void> _openVideo(BuildContext context) async {
    final url = videoUrl;
    if (url == null) return;

    var launched = false;
    try {
      launched = await _launcher(Uri.parse(url));
    } catch (_) {
      launched = false;
    }

    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the video link.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (videoUrl == null && gifUrl == null) {
      return const _MediaPlaceholder(message: 'No media available.');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (gifUrl != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              gifUrl!,
              height: 220,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const SizedBox(
                  height: 220,
                  child: Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder: (context, error, stackTrace) =>
                  const _MediaPlaceholder(message: 'Preview unavailable.'),
            ),
          ),
        if (videoUrl != null) ...[
          if (gifUrl != null) const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _openVideo(context),
            icon: const Icon(Icons.play_circle_outline),
            label: const Text('Watch video'),
          ),
        ],
      ],
    );
  }
}

class _MediaPlaceholder extends StatelessWidget {
  const _MediaPlaceholder({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(message, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}
