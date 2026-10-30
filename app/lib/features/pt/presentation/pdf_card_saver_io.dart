import 'dart:io';
import 'dart:typed_data';

import 'package:share_plus/share_plus.dart';

/// Hands a written file to the platform share/open sheet.
typedef ShareFile = Future<void> Function(String path, String filename);

Future<void> _shareWithSystem(String path, String filename) async {
  await SharePlus.instance.share(
    ShareParams(
      files: [XFile(path, mimeType: 'application/pdf')],
      title: filename,
    ),
  );
}

/// Writes the presentation card to a file, then opens the share sheet so the
/// user can save, print, or send it. Returns the written path.
Future<String?> savePresentationCard(
  String filename,
  Uint8List bytes, {
  ShareFile share = _shareWithSystem,
}) async {
  final safe = filename.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
  final file = File(
    '${Directory.systemTemp.path}${Platform.pathSeparator}$safe',
  );
  await file.writeAsBytes(bytes, flush: true);
  await share(file.path, safe);
  return file.path;
}
