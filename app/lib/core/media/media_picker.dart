import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

/// Bytes + MIME type of a file picked via camera, gallery, or the document
/// picker. `null` return from any [MediaPicker] method means the user
/// cancelled — never an error.
class PickedMedia {
  const PickedMedia({required this.bytes, required this.mimeType});

  final Uint8List bytes;
  final String mimeType;
}

/// Wraps `image_picker` (camera/gallery) and `file_picker` (arbitrary
/// documents). Both plugins request the underlying OS runtime permission
/// (camera / photo library) themselves on first use and surface a `null`
/// pick if the user denies it — no separate permission plumbing needed here.
@lazySingleton
class MediaPicker {
  MediaPicker() : _imagePicker = ImagePicker();

  /// Test-only seam for injecting a fake [ImagePicker] — not resolved by DI.
  @visibleForTesting
  MediaPicker.withImagePicker(this._imagePicker);

  final ImagePicker _imagePicker;

  Future<PickedMedia?> pickFromCamera() =>
      _pickImage(source: ImageSource.camera);

  Future<PickedMedia?> pickFromGallery() =>
      _pickImage(source: ImageSource.gallery);

  Future<PickedMedia?> _pickImage({required ImageSource source}) async {
    final file = await _imagePicker.pickImage(source: source);
    if (file == null) return null;

    final bytes = await file.readAsBytes();
    return PickedMedia(
      bytes: bytes,
      mimeType: file.mimeType ?? _mimeTypeFromExtension(file.path),
    );
  }

  /// Opens the OS document picker restricted to PDF/image documents.
  Future<PickedMedia?> pickDocument() async {
    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (files.isEmpty) return null;

    final file = files.single;
    final bytes = await file.readAsBytes();
    return PickedMedia(
      bytes: bytes,
      mimeType: _mimeTypeFromExtension(file.name),
    );
  }

  String _mimeTypeFromExtension(String path) {
    final lower = path.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    if (lower.endsWith('.pdf')) return 'application/pdf';
    return 'image/jpeg';
  }
}
