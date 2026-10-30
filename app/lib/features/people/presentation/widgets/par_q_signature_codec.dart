import 'dart:convert';

import 'package:flutter/material.dart';

/// Stroke payload stored in `client_signature` (OpenAPI: data URL or strokes).
String encodeParQSignature(List<List<Offset>> strokes) {
  final kept = [
    for (final stroke in strokes)
      if (stroke.isNotEmpty)
        [
          for (final point in stroke)
            [
              double.parse(point.dx.toStringAsFixed(1)),
              double.parse(point.dy.toStringAsFixed(1)),
            ],
        ],
  ];
  return jsonEncode({'strokes': kept});
}
