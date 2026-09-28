import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
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
      listenWhen: (previous, next) {
        if (next.message != null && next.message != previous.message) {
          return true;
        }
        return next.pass != null &&
            next.failure != null &&
            next.failure != previous.failure;
      },
      listener: (context, state) {
        final text =
            state.message ??
            (state.failure == null ? null : failureMessage(state.failure!));
        if (text == null) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(text)));
      },
      builder: (context, state) {
        final pass = state.pass;
        final openAttendance = state.openAttendance;
        final actionInFlight = state.actionInFlight;
        final Widget body;
        if (state.status == LoadStatus.loading && pass == null) {
          body = const AppLoading();
        } else if (state.status == LoadStatus.failure && pass == null) {
          body = AppErrorView(
            message: state.failure == null
                ? ''
                : failureMessage(state.failure!),
            onRetry: () => context.read<AttendancePassCubit>().load(),
          );
        } else if (pass == null) {
          body = const AppLoading();
        } else {
          body = ListView(
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
              );
        }
        return Scaffold(
          appBar: AppBar(title: const Text(AttendanceStrings.passTitle)),
          body: body,
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
          if (state.status == LoadStatus.loading && state.items.isEmpty) {
            return const AppLoading();
          }
          if (state.status == LoadStatus.failure && state.items.isEmpty) {
            return AppErrorView(
              message: state.failure == null
                  ? ''
                  : failureMessage(state.failure!),
              onRetry: () =>
                  context.read<AttendanceHistoryCubit>().load(userId: userId),
            );
          }
          if (state.items.isEmpty) {
            return const AppEmptyView(message: AttendanceStrings.emptyHistory);
          }
          final items = state.items;
          return ListView.builder(
            itemCount: items.length + (state.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= items.length) {
                if (!state.loadingMore) {
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
                title: Text('${r.checkInTime} · ${r.method.label}'),
                subtitle: Text(
                  r.checkOutTime == null ? 'Open' : 'Out ${r.checkOutTime}',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
