import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../domain/entities/attendance_enums.dart';
import '../attendance_strings.dart';
import '../cubit/attendance_history_cubit.dart';
import '../cubit/attendance_pass_cubit.dart';

class AdminAttendanceScreen extends StatelessWidget {
  const AdminAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AttendanceLiveFeedCubit>()..load(),
      child: const _AdminAttendanceBody(),
    );
  }
}

class _AdminAttendanceBody extends StatelessWidget {
  const _AdminAttendanceBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AttendanceStrings.adminTitle),
        actions: [
          IconButton(
            tooltip: AttendanceStrings.scanQr,
            onPressed: () => context.push(Routes.adminAttendanceScan),
            icon: const Icon(Icons.qr_code_scanner),
          ),
          IconButton(
            tooltip: AttendanceStrings.manualOverride,
            onPressed: () => context.push(Routes.adminAttendanceManual),
            icon: const Icon(Icons.person_add_alt),
          ),
        ],
      ),
      body: BlocBuilder<AttendanceLiveFeedCubit, LiveFeedState>(
        builder: (context, state) {
          return switch (state) {
            LiveFeedLoading() => const AppLoading(),
            LiveFeedFailure(:final message) => AppErrorView(
              message: message,
              onRetry: () => context.read<AttendanceLiveFeedCubit>().load(),
            ),
            LiveFeedLoaded(:final items, :final footfall) => RefreshIndicator(
              onRefresh: () => context.read<AttendanceLiveFeedCubit>().load(),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    AttendanceStrings.footfall,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 72,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: footfall.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final day = footfall[index];
                        final max = footfall
                            .map((d) => d.totalMemberCheckins)
                            .fold<int>(1, (a, b) => a > b ? a : b);
                        final height =
                            48 * (day.totalMemberCheckins / max).clamp(0.1, 1.0);
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 16,
                              height: height,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            Text(
                              '${day.date.month}/${day.date.day}',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    AttendanceStrings.liveFeed,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (items.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: AppEmptyView(
                        message: AttendanceStrings.emptyFeed,
                      ),
                    )
                  else
                    ...items.map(
                      (r) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('User #${r.userId} · ${r.method.label}'),
                        subtitle: Text(
                          '${r.checkInTime}'
                          '${r.checkOutTime == null ? ' · open' : ' → ${r.checkOutTime}'}',
                        ),
                      ),
                    ),
                ],
              ),
            ),
          };
        },
      ),
    );
  }
}

class ManualCheckInScreen extends StatefulWidget {
  const ManualCheckInScreen({super.key});

  @override
  State<ManualCheckInScreen> createState() => _ManualCheckInScreenState();
}

class _ManualCheckInScreenState extends State<ManualCheckInScreen> {
  final _userIdController = TextEditingController();
  final _gateController = TextEditingController();

  @override
  void dispose() {
    _userIdController.dispose();
    _gateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CheckInCubit>(),
      child: BlocConsumer<CheckInCubit, CheckInCubitState>(
        listener: (context, state) {
          if (state is CheckInSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(AttendanceStrings.checkInSuccess)),
            );
            context.pop();
          } else if (state is CheckInIdle && state.message != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message!)));
          }
        },
        builder: (context, state) {
          final busy = state is CheckInIdle && state.actionInFlight;
          return Scaffold(
            appBar: AppBar(
              title: const Text(AttendanceStrings.manualOverride),
            ),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextField(
                  controller: _userIdController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: AttendanceStrings.userIdLabel,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _gateController,
                  decoration: const InputDecoration(
                    labelText: AttendanceStrings.gateLabel,
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: busy
                      ? null
                      : () {
                          final id = _userIdController.text.trim();
                          if (id.isEmpty) return;
                          context.read<CheckInCubit>().submit(
                            userId: id,
                            method: AttendanceCheckInMethod.manualOverride,
                            gateIdentifier: _gateController.text.trim().isEmpty
                                ? null
                                : _gateController.text.trim(),
                          );
                        },
                  child: Text(
                    busy
                        ? AttendanceStrings.submitting
                        : AttendanceStrings.manualOverride,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class QrScanCheckInScreen extends StatefulWidget {
  const QrScanCheckInScreen({super.key});

  @override
  State<QrScanCheckInScreen> createState() => _QrScanCheckInScreenState();
}

class _QrScanCheckInScreenState extends State<QrScanCheckInScreen> {
  final _payloadController = TextEditingController();
  String? _cameraError;
  bool _handledScan = false;
  late final MobileScannerController _scanner;
  late final CheckInCubit _cubit;

  @override
  void initState() {
    super.initState();
    _scanner = MobileScannerController();
    _cubit = getIt<CheckInCubit>();
  }

  @override
  void dispose() {
    _payloadController.dispose();
    _scanner.dispose();
    _cubit.close();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handledScan) return;
    String? raw;
    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue;
      if (value != null && value.isNotEmpty) {
        raw = value;
        break;
      }
    }
    if (raw == null) return;
    _handledScan = true;
    _payloadController.text = raw;
    _cubit.submit(
      method: AttendanceCheckInMethod.qrCode,
      payload: raw,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<CheckInCubit, CheckInCubitState>(
        listener: (context, state) {
          if (state is CheckInSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(AttendanceStrings.checkInSuccess)),
            );
            context.pop();
          } else if (state is CheckInIdle && state.message != null) {
            _handledScan = false;
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message!)));
          }
        },
        builder: (context, state) {
          final busy = state is CheckInIdle && state.actionInFlight;
          return Scaffold(
            appBar: AppBar(title: const Text(AttendanceStrings.scanQr)),
            body: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: _cameraError != null
                      ? AppErrorView(
                          message: _cameraError!,
                          onRetry: () {
                            setState(() => _cameraError = null);
                            _scanner.start();
                          },
                        )
                      : MobileScanner(
                          controller: _scanner,
                          onDetect: _onDetect,
                          errorBuilder: (context, error) {
                            final msg =
                                error.errorCode ==
                                    MobileScannerErrorCode.permissionDenied
                                ? AttendanceStrings.cameraPermissionDenied
                                : AttendanceStrings.cameraUnavailable;
                            if (_cameraError != msg) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (mounted) {
                                  setState(() => _cameraError = msg);
                                }
                              });
                            }
                            return Center(child: Text(msg));
                          },
                        ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      TextField(
                        controller: _payloadController,
                        decoration: const InputDecoration(
                          labelText: AttendanceStrings.payloadLabel,
                        ),
                      ),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: busy
                            ? null
                            : () {
                                final payload =
                                    _payloadController.text.trim();
                                if (payload.isEmpty) return;
                                _cubit.submit(
                                  method: AttendanceCheckInMethod.qrCode,
                                  payload: payload,
                                );
                              },
                        child: Text(
                          busy
                              ? AttendanceStrings.submitting
                              : AttendanceStrings.manualOverride,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
