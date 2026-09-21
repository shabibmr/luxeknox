import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../attendance_strings.dart';
import '../cubit/attendance_history_cubit.dart';
import '../cubit/attendance_pass_cubit.dart';
import '../../domain/entities/attendance_enums.dart';

class AttendancePassScreen extends StatelessWidget {
  const AttendancePassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AttendancePassCubit>()..load(),
      child: const _AttendancePassBody(),
    );
  }
}

class _AttendancePassBody extends StatelessWidget {
  const _AttendancePassBody();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AttendancePassCubit, AttendancePassState>(
      listenWhen: (p, n) => n is AttendancePassLoaded && n.message != null,
      listener: (context, state) {
        if (state is AttendancePassLoaded && state.message != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message!)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text(AttendanceStrings.passTitle)),
          body: switch (state) {
            AttendancePassLoading() => const AppLoading(),
            AttendancePassFailure(:final message) => AppErrorView(
              message: message,
              onRetry: () => context.read<AttendancePassCubit>().load(),
            ),
            AttendancePassLoaded(
              :final pass,
              :final openAttendance,
              :final actionInFlight,
            ) =>
              ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  if (pass.isExpired)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        AttendanceStrings.passExpired,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  Center(
                    child: QrImageView(
                      data: pass.payload,
                      version: QrVersions.auto,
                      size: 220,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SelectableText(
                    pass.payload,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${AttendanceStrings.expiresAt}: ${pass.expiresAt}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: actionInFlight
                        ? null
                        : () =>
                              context.read<AttendancePassCubit>().refreshPass(),
                    child: const Text(AttendanceStrings.refreshPass),
                  ),
                  if (openAttendance != null) ...[
                    const SizedBox(height: 24),
                    Text(
                      AttendanceStrings.openSession,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text('Since ${openAttendance.checkInTime}'),
                    const SizedBox(height: 8),
                    FilledButton(
                      onPressed: actionInFlight
                          ? null
                          : () =>
                                context.read<AttendancePassCubit>().checkOut(),
                      child: Text(
                        actionInFlight
                            ? AttendanceStrings.submitting
                            : AttendanceStrings.checkOut,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(AttendanceStrings.historyLink),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () =>
                        context.push(Routes.memberProfileAttendanceHistory),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(AttendanceStrings.summaryLink),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () =>
                        context.push(Routes.memberProfileAttendanceSummary),
                  ),
                ],
              ),
          },
        );
      },
    );
  }
}

class AttendanceHistoryScreen extends StatelessWidget {
  const AttendanceHistoryScreen({super.key, this.userId});

  final String? userId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AttendanceHistoryCubit>()..load(userId: userId),
      child: _AttendanceHistoryBody(userId: userId),
    );
  }
}

class _AttendanceHistoryBody extends StatelessWidget {
  const _AttendanceHistoryBody({this.userId});

  final String? userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AttendanceStrings.historyTitle)),
      body: BlocBuilder<AttendanceHistoryCubit, AttendanceHistoryState>(
        builder: (context, state) {
          return switch (state) {
            AttendanceHistoryLoading() => const AppLoading(),
            AttendanceHistoryFailure(:final message) => AppErrorView(
              message: message,
              onRetry: () =>
                  context.read<AttendanceHistoryCubit>().load(userId: userId),
            ),
            AttendanceHistoryLoaded(:final items, :final hasMore, :final loadingMore) =>
              items.isEmpty
                  ? const AppEmptyView(message: AttendanceStrings.emptyHistory)
                  : ListView.builder(
                      itemCount: items.length + (hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= items.length) {
                          if (!loadingMore) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              context.read<AttendanceHistoryCubit>().loadMore();
                            });
                          }
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: AppLoading(),
                          );
                        }
                        final r = items[index];
                        return ListTile(
                          title: Text(
                            '${r.checkInTime} · ${r.method.label}',
                          ),
                          subtitle: Text(
                            r.checkOutTime == null
                                ? 'Open'
                                : 'Out ${r.checkOutTime}',
                          ),
                        );
                      },
                    ),
          };
        },
      ),
    );
  }
}
