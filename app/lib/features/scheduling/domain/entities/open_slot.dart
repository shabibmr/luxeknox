import 'package:equatable/equatable.dart';

/// A free time interval derived from trainer availability minus busy blocks.
class OpenSlot extends Equatable {
  const OpenSlot({required this.start, required this.end});

  final DateTime start;
  final DateTime end;

  Duration get duration => end.difference(start);

  @override
  List<Object?> get props => [start, end];
}

/// An [OpenSlot] that maps to an existing bookable [ScheduleSession].
class BookableOpenSlot extends Equatable {
  const BookableOpenSlot({
    required this.scheduleId,
    required this.start,
    required this.end,
    required this.title,
  });

  final String scheduleId;
  final DateTime start;
  final DateTime end;
  final String title;

  @override
  List<Object?> get props => [scheduleId, start, end, title];
}
