/// Counter Sale line charge arithmetic.
///
/// Matches the inventory contract: gross = qty × sale rate (half-up to 2
/// decimals); tax = gross × rate% / 100 (half-up to 2) when a tax rate is
/// present; charge = gross + tax. No discount.
library;

String saleLineCharge({
  required String quantity,
  required String saleRate,
  String? taxRatePercent,
}) {
  final gross = _mulQtyRate(quantity, saleRate);
  final tax = _taxAmount(gross, taxRatePercent);
  return _addMoney(gross, tax);
}

String sumCharges(Iterable<String> charges) {
  var total = '0.00';
  for (final c in charges) {
    total = _addMoney(total, c);
  }
  return total;
}

String unitCharge({
  required String saleRate,
  String? taxRatePercent,
}) =>
    saleLineCharge(
      quantity: '1',
      saleRate: saleRate,
      taxRatePercent: taxRatePercent,
    );

String _taxAmount(String gross, String? taxRatePercent) {
  final raw = taxRatePercent?.trim() ?? '';
  if (raw.isEmpty) return '0.00';
  return _mulMoneyPercent(gross, raw);
}

/// Half-up money string (2 decimals).
String _roundMoney(String amount) {
  final str = amount.trim();
  final match = RegExp(r'^(-?)(\d+)(?:\.(\d+))?$').firstMatch(str);
  if (match == null) {
    throw FormatException('Invalid money: $amount');
  }
  final neg = match.group(1) == '-';
  final intPart = match.group(2)!;
  final frac = match.group(3) ?? '';
  final d1 = frac.isNotEmpty ? frac[0] : '0';
  final d2 = frac.length > 1 ? frac[1] : '0';
  final d3 = frac.length > 2 ? frac[2] : '0';
  var cents = BigInt.parse(intPart) * BigInt.from(100) +
      BigInt.parse(d1) * BigInt.from(10) +
      BigInt.parse(d2);
  if (int.parse(d3) >= 5) {
    cents += BigInt.one;
  }
  final centsStr = cents.toString().padLeft(3, '0');
  final whole = centsStr.substring(0, centsStr.length - 2);
  final f = centsStr.substring(centsStr.length - 2);
  final formatted = '$whole.$f';
  return neg && cents > BigInt.zero ? '-$formatted' : formatted;
}

BigInt _toCents(String amount) {
  final rounded = _roundMoney(amount);
  final neg = rounded.startsWith('-');
  final unsigned = neg ? rounded.substring(1) : rounded;
  final parts = unsigned.split('.');
  final whole = parts[0];
  final frac = (parts.length > 1 ? parts[1] : '00').padRight(2, '0').substring(0, 2);
  final cents = BigInt.parse(whole) * BigInt.from(100) + BigInt.parse(frac);
  return neg ? -cents : cents;
}

String _fromCents(BigInt cents) {
  final neg = cents < BigInt.zero;
  final abs = neg ? -cents : cents;
  final whole = abs ~/ BigInt.from(100);
  final frac = (abs % BigInt.from(100)).toString().padLeft(2, '0');
  return '${neg ? '-' : ''}$whole.$frac';
}

String _addMoney(String a, String b) => _fromCents(_toCents(a) + _toCents(b));

BigInt _toScaled(String value, int scale, String label) {
  final str = value.trim();
  final match = RegExp(r'^(-?)(\d+)(?:\.(\d+))?$').firstMatch(str);
  if (match == null) {
    throw FormatException('Invalid $label: $value');
  }
  final sign = match.group(1)!;
  final intPart = match.group(2)!;
  final fracPart = match.group(3) ?? '';
  if (fracPart.length > scale) {
    throw FormatException('Invalid $label: $value has more than $scale decimal places');
  }
  final units = BigInt.parse(intPart) * _pow10(scale) +
      BigInt.parse(fracPart.padRight(scale, '0').isEmpty ? '0' : fracPart.padRight(scale, '0'));
  return sign == '-' ? -units : units;
}

BigInt _pow10(int n) {
  var r = BigInt.one;
  for (var i = 0; i < n; i++) {
    r *= BigInt.from(10);
  }
  return r;
}

/// qty (≤3 dp) × rate (≤2 dp) → money half-up.
String _mulQtyRate(String quantity, String rate) {
  final raw = _toScaled(quantity, 3, 'quantity') * _toScaled(rate, 2, 'rate');
  final denom = BigInt.from(1000);
  final half = denom ~/ BigInt.from(2);
  final quot = raw >= BigInt.zero
      ? (raw + half) ~/ denom
      : (raw - half) ~/ denom;
  return _fromCents(quot);
}

String _mulMoneyPercent(String amount, String percent) {
  final amountCents = _toCents(amount);
  final pct = _roundMoney(percent);
  final unsigned = pct.replaceFirst('-', '');
  final parts = unsigned.split('.');
  final pWhole = parts[0];
  final pFrac = (parts.length > 1 ? parts[1] : '').padRight(2, '0').substring(0, 2);
  final pctBp = BigInt.parse(pWhole) * BigInt.from(100) + BigInt.parse(pFrac);
  final raw = amountCents * pctBp;
  final denom = BigInt.from(10000);
  final half = denom ~/ BigInt.from(2);
  final quot = raw >= BigInt.zero
      ? (raw + half) ~/ denom
      : (raw - half) ~/ denom;
  return _fromCents(quot);
}
