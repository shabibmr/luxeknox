// Half-up money helpers for Counter Sale display totals.
// Matches the inventory contract: quantity × rate, then tax on the net,
// each step half-up to 2 decimals so the tile charge matches what the
// server will post for quantity 1 with no discount.

BigInt _toCents(String amount) {
  final rounded = roundMoney(amount);
  final negative = rounded.startsWith('-');
  final unsigned = negative ? rounded.substring(1) : rounded;
  final parts = unsigned.split('.');
  final whole = BigInt.parse(parts[0]);
  final frac = (parts.length > 1 ? parts[1] : '00').padRight(2, '0').substring(0, 2);
  final cents = whole * BigInt.from(100) + BigInt.parse(frac);
  return negative ? -cents : cents;
}

String _fromCents(BigInt cents) {
  final negative = cents.isNegative;
  final abs = negative ? -cents : cents;
  final whole = abs ~/ BigInt.from(100);
  final frac = (abs % BigInt.from(100)).toString().padLeft(2, '0');
  return '${negative ? '-' : ''}$whole.$frac';
}

/// Round half-up to 2 decimals (ties away from zero).
String roundMoney(String amount) {
  final str = amount.trim();
  if (!RegExp(r'^-?\d+(\.\d+)?$').hasMatch(str)) {
    throw FormatException('Invalid money amount: "$amount"');
  }
  final negative = str.startsWith('-');
  final unsigned = negative ? str.substring(1) : str;
  final parts = unsigned.split('.');
  final intPart = parts[0];
  final fracPart = parts.length > 1 ? parts[1] : '';
  final d1 = fracPart.isNotEmpty ? fracPart[0] : '0';
  final d2 = fracPart.length > 1 ? fracPart[1] : '0';
  final d3 = fracPart.length > 2 ? fracPart[2] : '0';
  var cents = BigInt.parse(intPart) * BigInt.from(100) +
      BigInt.parse(d1) * BigInt.from(10) +
      BigInt.parse(d2);
  if (int.parse(d3) >= 5) {
    cents += BigInt.one;
  }
  final centsStr = cents.toString().padLeft(3, '0');
  final whole = centsStr.substring(0, centsStr.length - 2);
  final frac = centsStr.substring(centsStr.length - 2);
  final formatted = '$whole.$frac';
  return negative && cents > BigInt.zero ? '-$formatted' : formatted;
}

String addMoney(String a, String b) => _fromCents(_toCents(a) + _toCents(b));

/// Multiply money by a percent (e.g. `"18.00"` → 18%) half-up to cents.
String mulMoneyPercent(String amount, String percent) {
  final amountCents = _toCents(amount);
  final pct = roundMoney(percent);
  final unsigned = pct.replaceFirst(RegExp(r'^-'), '');
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

/// Charge for one unit at [saleRate], including tax when [taxRatePercent] is set.
String unitCharge({required String saleRate, String? taxRatePercent}) {
  final gross = roundMoney(saleRate);
  if (taxRatePercent == null || taxRatePercent.trim().isEmpty) {
    return gross;
  }
  final tax = mulMoneyPercent(gross, taxRatePercent);
  return addMoney(gross, tax);
}
