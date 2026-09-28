# Phase 15 Media — status (2026-09-21)

## Implemented
- **Signed Upload**: Hardened [`MediaUploader`](file:///Users/admin/code/gym/app/lib/core/media/media_uploader.dart) with direct `MediaUploadRequestPurposeEnum` enum mapping, explicit `CancelToken` support, and unit tests covering successful upload, cancelation, and API failure paths.
- **Upload Progress**: Created reusable [`UploadProgressWidget`](file:///Users/admin/code/gym/app/lib/core/media/upload_progress_widget.dart) displaying formatted progress (`X MB / Y MB`, percentage), cancellation action, and error banner with retry.
- **Retry / Cancel**: Full cancelation token lifecycle in `MediaUploader` and `MediaDownloader`, with error retry capabilities wired into upload progress and link widgets.
- **Signed Download**: Implemented [`MediaDownloader`](file:///Users/admin/code/gym/app/lib/core/media/media_downloader.dart) using plain Dio for raw pre-authorized byte downloads with cancel tokens and progress tracking.
- **Parent Access Checks**: Consolidated `canAccessDocument` (BR-HEALTH-001 denying trainers `id_proof` and `waiver`), `canAccessMemberMediaParent` (row-level scope checking member ownership, assigned trainer status, and health capability), and `canDeleteMedia` (FR-MEDIA-004 ensuring receipts cannot be deleted by members).
- **MIME & Size Handling**: Aligned [`MediaPurpose`](file:///Users/admin/code/gym/app/lib/core/media/media_purpose.dart) with ADR-0008 contract (avatar 5MB, id_proof/waiver/medical_cert 10MB, progress_photo 8MB, exercise_media 50MB with video/gif, receipt_pdf 5MB), and expanded [`MediaPicker`](file:///Users/admin/code/gym/app/lib/core/media/media_picker.dart) MIME detection.
- **Image Compression & Thumbnails**: Implemented [`ImageCompressor`](file:///Users/admin/code/gym/app/lib/core/media/image_compressor.dart) for client-side image downscaling and thumbnail generation, preventing oversized camera uploads.
- **Document Preview**: Created interactive [`DocumentPreviewDialog`](file:///Users/admin/code/gym/app/lib/core/media/document_preview_dialog.dart) featuring zoomable image preview with [`SignedMediaImage`](file:///Users/admin/code/gym/app/lib/core/media/signed_media_image.dart), PDF external launch via [`SignedFileLink`](file:///Users/admin/code/gym/app/lib/core/media/signed_file_link.dart), and local file download via `MediaDownloader`. Wired document tap preview into [`DocumentsScreen`](file:///Users/admin/code/gym/app/lib/features/people/presentation/screens/documents_screen.dart).
- **Expired URL Recovery**: Added in-memory URL caching with TTL checking (`CachedSignedUrl.isExpired`) to [`SignedMediaResolver`](file:///Users/admin/code/gym/app/lib/core/media/signed_media_resolver.dart), with automatic recovery on image loading failures in `SignedMediaImage` and retry in `SignedFileLink`.

## Architecture & DI
- All services registered with GetIt/Injectable (`injector.config.dart` updated).
- Clear separation between authorized API requests (`MEDIAApi`) and direct binary streaming over signed S3/HMAC URLs (`_uploadDio`, `_downloadDio`).
- Pure Dart business logic for purpose limits, parent access, and recovery.

## Tests (`app/test/core/media/`)
- `media_purpose_test.dart` (ADR-0008 limit conformance)
- `media_uploader_test.dart` (signed upload, MIME/size rejection, cancelation)
- `signed_media_resolver_test.dart` (URL caching, expiry detection, forced refresh recovery)
- `media_downloader_test.dart` (signed download, cancelation, error mapping)
- `image_compressor_test.dart` (downscaling, compression, thumbnail generation)
- `document_access_test.dart` (BR-HEALTH-001, row-level parent checks, delete restrictions)
- `document_preview_dialog_test.dart` (access denial, PDF metadata view, image preview)
- `upload_progress_widget_test.dart` (progress bar, formatted bytes, cancel/retry triggers)

All 39 media tests passed (`flutter test test/core/media`). People tests passed without regressions (`flutter test test/features/people`). `flutter analyze` completed with 0 errors.
