import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/attendance_occupancy.dart';
import '../../domain/usecases/attendance_usecases.dart';
import '../attendance_strings.dart';

/// Small live tile showing current gate occupancy (open check-ins). Fetches
/// once on mount; pull-to-refresh on the parent screen does not re-trigger
/// it since occupancy is a point-in-time snapshot, not report-range data.
class AttendanceOccupancyTile extends StatefulWidget {
  const AttendanceOccupancyTile({super.key});

  @override
  State<AttendanceOccupancyTile> createState() =>
      _AttendanceOccupancyTileState();
}

class _AttendanceOccupancyTileState extends State<AttendanceOccupancyTile> {
  late Future<AttendanceOccupancy?> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<AttendanceOccupancy?> _load() async {
    final result = await getIt<GetAttendanceOccupancyUseCase>()(
      const NoParams(),
    );
    return result.fold((_) => null, (occupancy) => occupancy);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FutureBuilder<AttendanceOccupancy?>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: LinearProgressIndicator(),
          );
        }
        final occupancy = snapshot.data;
        if (occupancy == null) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Icon(Icons.error_outline, size: 18, color: theme.colorScheme.error),
                const SizedBox(width: 8),
                Text(
                  AttendanceStrings.occupancyLoadFailed,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          );
        }
        return Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.groups_outlined,
                color: theme.colorScheme.onPrimaryContainer,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AttendanceStrings.liveOccupancy,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    Text(
                      '${occupancy.checkedInNow} ${AttendanceStrings.checkedInNow}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                AttendanceStrings.asOf(DateFormat.Hm().format(occupancy.asOf)),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
