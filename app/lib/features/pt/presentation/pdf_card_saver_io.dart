import 'dart:io';
import 'dart:typed_data';

/// Writes the presentation card where the OS keeps temp files and returns
/// that path so the screen can show it.
Future<String?> savePresentationCard(String filename, Uint8List bytes) async {
  final safe = filename.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
  final file = File(
    '${Directory.systemTemp.path}${Platform.pathSeparator}$safe',
  );
  await file.writeAsBytes(bytes, flush: true);
  return file.path;
}
