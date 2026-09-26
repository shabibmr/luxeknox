import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/extensions/capability_extension.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../domain/entities/app_report_type.dart';
import '../cubit/report_cubit.dart';
import '../report_strings.dart';
import '../widgets/report_chart_section.dart';
import '../widgets/report_data_table.dart';
import '../widgets/report_date_range_bar.dart';
import '../widgets/report_filters_bar.dart';
import '../widgets/report_pagination_bar.dart';

class ReportViewerScreen extends StatelessWidget {
  const ReportViewerScreen({
    super.key,
    required this.category,
    this.trainerOwnLocked = false,
  });

  /// Path category (`members`, `revenue`, `trainer_own`, …).
  final String category;

  /// When true, forces trainer_own and hides trainer filter.
  final bool trainerOwnLocked;

  @override
  Widget build(BuildContext context) {
    final parsed = trainerOwnLocked
        ? AppReportType.trainerOwn
        : parseAppReportType(category);

    if (parsed == null) {
      return Scaffold(
        appBar: AppBar(title: const Text(ReportStrings.viewerTitle)),
        body: const AppErrorView(message: ReportStrings.unknownCategory),
      );
    }

    return BlocProvider(
      create: (_) => getIt<ReportCubit>()
        ..load(parsed, trainerOwnLocked: trainerOwnLocked),
      child: _ReportViewerBody(
        type: parsed,
        trainerOwnLocked: trainerOwnLocked,
      ),
    );
  }
}

class _ReportViewerBody extends StatefulWidget {
  const _ReportViewerBody({
    required this.type,
    required this.trainerOwnLocked,
  });

  final AppReportType type;
  final bool trainerOwnLocked;

  @override
  State<_ReportViewerBody> createState() => _ReportViewerBodyState();
}

class _ReportViewerBodyState extends State<_ReportViewerBody> {
  DateTime? _from;
  DateTime? _to;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _from = now.subtract(const Duration(days: 30));
    _to = now;
  }

  Future<void> _export() async {
    final cubit = context.read<ReportCubit>();
    final csv = await cubit.exportCsv();
    if (!mounted) return;
    if (csv == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(ReportStrings.exportFailed)),
      );
      return;
    }
    await Clipboard.setData(ClipboardData(text: csv));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(ReportStrings.exported)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canExport = context.can('reports.export');

    return Scaffold(
      appBar: AppBar(
        title: Text(ReportStrings.titleFor(widget.type)),
        actions: [
          if (canExport)
            IconButton(
              tooltip: ReportStrings.exportCsv,
              onPressed: () => _export(),
              icon: const Icon(Icons.download_outlined),
            ),
        ],
      ),
      body: BlocBuilder<ReportCubit, ReportState>(
        builder: (context, state) {
          final query = state.query;
          _from = query.from ?? _from;
          _to = query.to ?? _to;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ReportDateRangeBar(
                      from: _from,
                      to: _to,
                      onChanged: (from, to) {
                        setState(() {
                          _from = from;
                          _to = to;
                        });
                        context.read<ReportCubit>().applyFilters(
                              from: from,
                              to: to,
                              productId: query.productId,
                              trainerId: query.trainerId,
                            );
                      },
                    ),
                    const SizedBox(height: 12),
                    ReportFiltersBar(
                      type: widget.type,
                      productId: query.productId,
                      trainerId: query.trainerId,
                      lockTrainerId: widget.trainerOwnLocked,
                      onApply: ({productId, trainerId}) {
                        context.read<ReportCubit>().applyFilters(
                              from: _from,
                              to: _to,
                              productId: productId,
                              trainerId: trainerId,
                              clearProductId: productId == null,
                              clearTrainerId: trainerId == null,
                            );
                      },
                    ),
                  ],
                ),
              ),
              const Divider(height: 24),
              Expanded(child: _ReportBody(state: state)),
            ],
          );
        },
      ),
    );
  }
}

class _ReportBody extends StatelessWidget {
  const _ReportBody({required this.state});

  final ReportState state;

  @override
  Widget build(BuildContext context) {
    final result = state.result;
    if (state.status == LoadStatus.loading && result == null) {
      return const AppLoading();
    }
    if (state.status == LoadStatus.failure && result == null) {
      return AppErrorView(
        message: state.failure == null ? '' : failureMessage(state.failure!),
        onRetry: () => context.read<ReportCubit>().refresh(),
      );
    }
    if (result == null) return const AppLoading();
    final pageIndex = state.pageIndex;
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () => context.read<ReportCubit>().refresh(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (state.status == LoadStatus.failure && state.failure != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    failureMessage(state.failure!),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ReportChartSection(type: result.type, rows: result.rows),
              ReportPaginationBar(
                pageIndex: pageIndex,
                pageCount: state.pageCount,
                totalRows: result.rows.length,
                onPrevious: pageIndex > 0
                    ? () => context.read<ReportCubit>().setPage(pageIndex - 1)
                    : null,
                onNext: pageIndex < state.pageCount - 1
                    ? () => context.read<ReportCubit>().setPage(pageIndex + 1)
                    : null,
              ),
              const SizedBox(height: 8),
              ReportDataTable(columns: result.columns, rows: state.pageRows),
            ],
          ),
        ),
        if (state.exporting)
          const ColoredBox(
            color: Color(0x33000000),
            child: AppLoading(),
          ),
      ],
    );
  }
}
