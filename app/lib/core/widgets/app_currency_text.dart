import 'dart:async';

import 'package:flutter/material.dart';
import '../currency/gym_currency_provider.dart';
import '../di/injector.dart';

/// Formats a monetary value using the gym's configured currency.
///
/// Use this for display-only amounts. For editable monetary values, use
/// [AppCurrencyField]. Invalid or absent values are shown as an em dash.
class AppCurrencyText extends StatefulWidget {
  const AppCurrencyText(
    this.amount, {
    super.key,
    this.currencyCode,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final String? amount;
  final String? currencyCode;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  State<AppCurrencyText> createState() => _AppCurrencyTextState();
}

class _AppCurrencyTextState extends State<AppCurrencyText> {
  String? _resolvedCurrencyCode;

  @override
  void initState() {
    super.initState();
    unawaited(_loadCurrencyCode());
  }

  @override
  void didUpdateWidget(covariant AppCurrencyText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currencyCode != widget.currencyCode &&
        widget.currencyCode == null) {
      unawaited(_loadCurrencyCode());
    }
  }

  Future<void> _loadCurrencyCode() async {
    if (widget.currencyCode != null ||
        !getIt.isRegistered<GymCurrencyProvider>()) {
      return;
    }
    try {
      final code = await getIt<GymCurrencyProvider>().currencyCode();
      if (!mounted || code == _resolvedCurrencyCode) return;
      setState(() => _resolvedCurrencyCode = code);
    } catch (_) {
      // Display can safely fall back to INR when settings are unavailable.
    }
  }

  String _format() {
    return formatCurrencyAmount(
      widget.amount,
      currencyCode: widget.currencyCode ?? _resolvedCurrencyCode,
    );
  }

  @override
  Widget build(BuildContext context) => Text(
    _format(),
    style: widget.style,
    textAlign: widget.textAlign,
    maxLines: widget.maxLines,
    overflow: widget.overflow,
  );
}
