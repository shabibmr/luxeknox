import 'dart:typed_data';

/// Web and other non-IO targets confirm export without writing a file.
Future<String?> savePresentationCard(String filename, Uint8List bytes) async {
  return null;
}
