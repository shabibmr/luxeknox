import 'package:flutter/material.dart';

import '../report_strings.dart';

class ReportDateRangeBar extends StatelessWidget {
  const ReportDateRangeBar({
    super.key,
    required this.from,
    required this.to,
    required this.onChanged,
  });

  final DateTime? from;
  final DateTime? to;
  final void Function(DateTime? from, DateTime? to) onChanged;

  Future<void> _pick(
    BuildContext context, {
    required bool isFrom,
  }) async {
    final initial = (isFrom ? from : to) ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked == null) return;
    if (isFrom) {
      onChanged(picked, to);
    } else {
      onChanged(from, picked);
    }
  }

  String _label(DateTime? value) {
    if (value == null) return '—';
    String two(int n) => n.toString().padLeft(2, '0');
    return '${value.year}-${two(value.month)}-${two(value.day)}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ReportStrings.dateRangeTitle,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            OutlinedButton.icon(
              onPressed: () => _pick(context, isFrom: true),
              icon: const Icon(Icons.calendar_today_outlined, size: 16),
              label: Text('${ReportStrings.fromLabel}: ${_label(from)}'),
            ),
            OutlinedButton.icon(
              onPressed: () => _pick(context, isFrom: false),
              icon: const Icon(Icons.event_outlined, size: 16),
              label: Text('${ReportStrings.toLabel}: ${_label(to)}'),
            ),
          ],
        ),
      ],
    );
  }
}
