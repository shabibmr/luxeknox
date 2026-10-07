import 'package:equatable/equatable.dart';

enum PtGridCellStatus { free, occupied, unavailable }

class PtGridTrainer extends Equatable {
  const PtGridTrainer({required this.id, required this.name});

  final int id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}

class PtGridCell extends Equatable {
  const PtGridCell({
    required this.trainerId,
    required this.slotStart,
    required this.status,
    this.occupiedBy,
    this.conflictDates = const [],
  });

  final int trainerId;

  /// Gym wall-clock "HH:00:00".
  final String slotStart;
  final PtGridCellStatus status;
  final String? occupiedBy;
  final List<DateTime> conflictDates;

  @override
  List<Object?> get props => [
    trainerId,
    slotStart,
    status,
    occupiedBy,
    conflictDates,
  ];
}

/// Hours × active trainers for one PT period and weekday pattern. A cell is
/// free only when the trainer is available and clash-free on every PT day.
class PtScheduleGrid extends Equatable {
  const PtScheduleGrid({
    required this.startDate,
    required this.endDate,
    required this.weekdays,
    required this.hours,
    required this.trainers,
    required this.cells,
  });

  final DateTime startDate;
  final DateTime endDate;
  final List<int> weekdays;
  final List<String> hours;
  final List<PtGridTrainer> trainers;
  final List<PtGridCell> cells;

  PtGridCell? cell(int trainerId, String hour) {
    for (final c in cells) {
      if (c.trainerId == trainerId && c.slotStart == hour) return c;
    }
    return null;
  }

  @override
  List<Object?> get props => [
    startDate,
    endDate,
    weekdays,
    hours,
    trainers,
    cells,
  ];
}

/// "17:00:00" → "17:00-18:00".
String ptHourLabel(String slotStart) {
  final h = int.parse(slotStart.split(':').first);
  String two(int v) => v.toString().padLeft(2, '0');
  return '${two(h)}:00-${two(h + 1)}:00';
}

const ptWeekdayShortNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

String ptWeekdaysLabel(List<int> weekdays) =>
    ([...weekdays]..sort()).map((d) => ptWeekdayShortNames[d]).join(' / ');
