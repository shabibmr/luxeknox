import 'package:flutter/material.dart';

import '../report_strings.dart';

class ReportPaginationBar extends StatelessWidget {
  const ReportPaginationBar({
    super.key,
    required this.pageIndex,
    required this.pageCount,
    required this.totalRows,
    required this.onPrevious,
    required this.onNext,
  });

  final int pageIndex;
  final int pageCount;
  final int totalRows;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            ReportStrings.pageStatus(
              page: pageIndex + 1,
              pageCount: pageCount,
              totalRows: totalRows,
            ),
          ),
        ),
        TextButton(
          onPressed: onPrevious,
          child: const Text(ReportStrings.previousPage),
        ),
        TextButton(
          onPressed: onNext,
          child: const Text(ReportStrings.nextPage),
        ),
      ],
    );
  }
}
