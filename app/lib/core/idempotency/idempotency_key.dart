import 'dart:math';

/// Client-side [Idempotency-Key] generator for mutation APIs that accept one.
///
/// Callers should generate once per user intent and reuse the same key on
/// retries of that intent so the server can dedupe. A new user action must
/// mint a new key.
String newIdempotencyKey() {
  final now = DateTime.now().toUtc().microsecondsSinceEpoch;
  final rand = Random.secure().nextInt(1 << 32);
  return '$now-$rand';
}
