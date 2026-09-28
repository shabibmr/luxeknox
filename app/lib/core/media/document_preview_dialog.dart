import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../session/domain/entities/user_type.dart';
import 'document_access.dart';
import 'media_downloader.dart';
import 'signed_file_link.dart';
import 'signed_media_image.dart';
import 'signed_media_resolver.dart';

/// Modal dialog for previewing documents and images in-app (FR-MEDIA-003).
///
/// Enforces BR-HEALTH-001 access checks before presenting media, renders image
/// files in-place with zoom capabilities, and offers external viewing and download
/// for PDF/document assets.
class DocumentPreviewDialog extends StatelessWidget {
  const DocumentPreviewDialog({
    super.key,
    required this.objectKey,
    required this.title,
    required this.purpose,
    required this.viewerRole,
    this.contentType,
    this.fileSize,
    this.resolver,
    this.downloader,
  });

  final String objectKey;
  final String title;
  final DocumentPurpose purpose;
  final UserType viewerRole;
  final String? contentType;
  final int? fileSize;
  final SignedMediaResolver? resolver;
  final MediaDownloader? downloader;

  static Future<void> show(
    BuildContext context, {
    required String objectKey,
    required String title,
    required DocumentPurpose purpose,
    required UserType viewerRole,
    String? contentType,
    int? fileSize,
    SignedMediaResolver? resolver,
    MediaDownloader? downloader,
  }) {
    return showDialog(
      context: context,
      builder: (context) => DocumentPreviewDialog(
        objectKey: objectKey,
        title: title,
        purpose: purpose,
        viewerRole: viewerRole,
        contentType: contentType,
        fileSize: fileSize,
        resolver: resolver,
        downloader: downloader,
      ),
    );
  }

  bool get _isImage {
    if (contentType != null) {
      return contentType!.startsWith('image/');
    }
    return purpose == DocumentPurpose.progressPhoto;
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    final hasAccess = canAccessDocument(role: viewerRole, purpose: purpose);

    return Dialog(
      clipBehavior: Clip.antiAlias,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppBar(
              title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: !hasAccess
                    ? _AccessDeniedView()
                    : _isImage
                        ? _ImagePreview(
                            objectKey: objectKey,
                            resolver: resolver,
                          )
                        : _DocumentInfoView(
                            title: title,
                            purpose: purpose,
                            fileSize: fileSize != null
                                ? _formatBytes(fileSize!)
                                : null,
                            objectKey: objectKey,
                            resolver: resolver,
                            downloader: downloader,
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccessDeniedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lock_outline,
            size: 48,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Access Restricted',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.error,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Trainers are not permitted to view identity-proof or waiver files (BR-HEALTH-001).',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _ImagePreview extends StatelessWidget {
  const _ImagePreview({required this.objectKey, this.resolver});

  final String objectKey;
  final SignedMediaResolver? resolver;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: InteractiveViewer(
        minScale: 0.5,
        maxScale: 4.0,
        child: Center(
          child: SignedMediaImage(
            objectKey: objectKey,
            resolver: resolver,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class _DocumentInfoView extends StatefulWidget {
  const _DocumentInfoView({
    required this.title,
    required this.purpose,
    required this.objectKey,
    this.fileSize,
    this.resolver,
    this.downloader,
  });

  final String title;
  final DocumentPurpose purpose;
  final String objectKey;
  final String? fileSize;
  final SignedMediaResolver? resolver;
  final MediaDownloader? downloader;

  @override
  State<_DocumentInfoView> createState() => _DocumentInfoViewState();
}

class _DocumentInfoViewState extends State<_DocumentInfoView> {
  bool _isDownloading = false;
  String? _downloadStatus;

  Future<void> _handleDownload() async {
    final downloader =
        widget.downloader ?? (GetIt.instance.isRegistered<MediaDownloader>()
            ? GetIt.instance<MediaDownloader>()
            : null);
    if (downloader == null) return;

    setState(() {
      _isDownloading = true;
      _downloadStatus = null;
    });

    final result = await downloader.downloadBytes(
      objectKey: widget.objectKey,
    );

    if (!mounted) return;

    setState(() {
      _isDownloading = false;
      _downloadStatus = result.fold(
        (f) => 'Download failed',
        (bytes) => 'Downloaded ${bytes.lengthInBytes} bytes',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.picture_as_pdf,
              size: 64,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              widget.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Type: ${widget.purpose.name}',
              style: theme.textTheme.bodyMedium,
            ),
            if (widget.fileSize != null) ...[
              const SizedBox(height: 4),
              Text(
                'Size: ${widget.fileSize}',
                style: theme.textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 24),
            SignedFileLink(
              objectKey: widget.objectKey,
              label: 'Open Document',
              resolver: widget.resolver,
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _isDownloading ? null : _handleDownload,
              icon: _isDownloading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.download),
              label: const Text('Download Copy'),
            ),
            if (_downloadStatus != null) ...[
              const SizedBox(height: 8),
              Text(
                _downloadStatus!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: _downloadStatus!.contains('failed')
                      ? theme.colorScheme.error
                      : theme.colorScheme.primary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
