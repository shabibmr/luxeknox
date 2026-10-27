/// Compare two non-negative quantity strings (up to 3 decimal places).
///
/// Returns negative if [a] < [b], zero if equal, positive if [a] > [b].
int compareQuantity(String a, String b) {
  return _toScaled(a) - _toScaled(b);
}

bool quantityExceeds(String quantity, String onHand) {
  return compareQuantity(quantity, onHand) > 0;
}

int _toScaled(String value) {
  final str = value.trim();
  final match = RegExp(r'^(\d+)(?:\.(\d+))?$').firstMatch(str);
  if (match == null) {
    throw FormatException('Invalid quantity: $value');
  }
  final whole = match.group(1)!;
  final frac = (match.group(2) ?? '').padRight(3, '0').substring(0, 3);
  return int.parse(whole) * 1000 + int.parse(frac.isEmpty ? '0' : frac);
}
