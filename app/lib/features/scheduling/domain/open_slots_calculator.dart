import 'entities/open_slot.dart';
import 'entities/schedule_catalog.dart';
import 'entities/schedule_enums.dart';
import 'entities/schedule_session.dart';

/// Pure helpers: trainer availability windows − busy sessions → open slots.
///
/// Mirrors `apps/api/src/sched/slot-calculation.ts` so client and server agree
/// until an open-slots API (B3) ships. Day-of-week uses Sunday=0 … Saturday=6
/// (same as the API `day_of_week` field).
class OpenSlotsCalculator {
  const OpenSlotsCalculator._();

  static final _timePattern = RegExp(r'^(\d{2}):(\d{2})(?::(\d{2}))?$');

  /// Parses `HH:MM` or `HH:MM:SS` into minutes from midnight.
  static int parseTimeToMinutes(String time) {
    final match = _timePattern.firstMatch(time);
    if (match == null) {
      throw FormatException('Invalid time format: $time');
    }
    final hours = int.parse(match.group(1)!);
    final minutes = int.parse(match.group(2)!);
    return hours * 60 + minutes;
  }

  /// Combines a `yyyy-MM-dd` calendar date with a wall-clock time string.
  ///
  /// Uses a local [DateTime] so results align with schedule times mapped via
  /// `toLocal()` in the scheduling mappers.
  static DateTime combineDateAndTime(String dateIso, String time) {
    final parts = dateIso.split('-').map(int.parse).toList();
    if (parts.length != 3) {
      throw FormatException('Invalid date format: $dateIso');
    }
    final minutes = parseTimeToMinutes(time);
    return DateTime(
      parts[0],
      parts[1],
      parts[2],
      minutes ~/ 60,
      minutes % 60,
    );
  }

  /// Formats a local/UTC date as `yyyy-MM-dd`.
  static String toDateIso(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// JS/`getUTCDay` style: Sunday=0 … Saturday=6.
  static int dayOfWeekSunday0(DateTime date) => date.weekday % 7;

  static List<OpenSlot> mergeIntervals(List<OpenSlot> intervals) {
    if (intervals.isEmpty) return const [];
    final sorted = [...intervals]
      ..sort((a, b) => a.start.compareTo(b.start));
    final merged = <OpenSlot>[
      OpenSlot(start: sorted.first.start, end: sorted.first.end),
    ];

    for (var i = 1; i < sorted.length; i++) {
      final current = sorted[i];
      final last = merged.last;
      if (!current.start.isAfter(last.end)) {
        if (current.end.isAfter(last.end)) {
          merged[merged.length - 1] = OpenSlot(
            start: last.start,
            end: current.end,
          );
        }
      } else {
        merged.add(OpenSlot(start: current.start, end: current.end));
      }
    }
    return merged;
  }

  static List<OpenSlot> subtractBusyIntervals(
    List<OpenSlot> available,
    List<OpenSlot> busy,
  ) {
    final mergedBusy = mergeIntervals(busy);
    final open = <OpenSlot>[];

    for (final window in available) {
      var cursor = window.start;
      for (final block in mergedBusy) {
        if (!block.end.isAfter(cursor) || !block.start.isBefore(window.end)) {
          continue;
        }
        if (block.start.isAfter(cursor)) {
          open.add(OpenSlot(start: cursor, end: block.start));
        }
        if (block.end.isAfter(cursor)) {
          cursor = block.end;
        }
      }
      if (cursor.isBefore(window.end)) {
        open.add(OpenSlot(start: cursor, end: window.end));
      }
    }
    return open;
  }

  static List<OpenSlot> splitIntoSlots(
    List<OpenSlot> intervals,
    int slotDurationMinutes,
  ) {
    if (slotDurationMinutes <= 0) return const [];
    final slots = <OpenSlot>[];
    final duration = Duration(minutes: slotDurationMinutes);

    for (final interval in intervals) {
      var cursor = interval.start;
      while (!cursor.add(duration).isAfter(interval.end)) {
        final end = cursor.add(duration);
        slots.add(OpenSlot(start: cursor, end: end));
        cursor = end;
      }
    }
    return slots;
  }

  /// Builds availability windows for one calendar day from recurring + override
  /// rows (domain [TrainerAvailabilitySlot]s).
  static List<OpenSlot> buildDayAvailabilityWindows({
    required String dateIso,
    required List<TrainerAvailabilitySlot> availability,
  }) {
    final date = combineDateAndTime(dateIso, '00:00:00');
    final dow = dayOfWeekSunday0(date);

    final recurringForDay = availability.where(
      (row) =>
          (row.isRecurring ?? false) &&
          row.dayOfWeek == dow &&
          row.isAvailable &&
          row.startTime != null &&
          row.endTime != null,
    );
    var windows = mergeIntervals(
      recurringForDay
          .map(
            (row) => OpenSlot(
              start: combineDateAndTime(dateIso, row.startTime!),
              end: combineDateAndTime(dateIso, row.endTime!),
            ),
          )
          .toList(),
    );

    final dayOverrides = availability.where((row) {
      if (row.isRecurring ?? true) return false;
      final override = row.overrideDate;
      if (override == null) return false;
      return toDateIso(override) == dateIso;
    }).toList();

    if (dayOverrides.isEmpty) return windows;

    final blocked = dayOverrides
        .where(
          (row) =>
              !row.isAvailable &&
              row.startTime != null &&
              row.endTime != null,
        )
        .map(
          (row) => OpenSlot(
            start: combineDateAndTime(dateIso, row.startTime!),
            end: combineDateAndTime(dateIso, row.endTime!),
          ),
        )
        .toList();
    windows = subtractBusyIntervals(windows, blocked);

    final extraAvailable = dayOverrides
        .where(
          (row) =>
              row.isAvailable &&
              row.startTime != null &&
              row.endTime != null,
        )
        .map(
          (row) => OpenSlot(
            start: combineDateAndTime(dateIso, row.startTime!),
            end: combineDateAndTime(dateIso, row.endTime!),
          ),
        )
        .toList();

    return mergeIntervals([...windows, ...extraAvailable]);
  }

  /// Availability for [dateIso] minus [busy], split into fixed-duration slots.
  static List<OpenSlot> computeOpenSlots({
    required String dateIso,
    required List<TrainerAvailabilitySlot> availability,
    required List<OpenSlot> busy,
    required int slotDurationMinutes,
  }) {
    final windows = buildDayAvailabilityWindows(
      dateIso: dateIso,
      availability: availability,
    );
    final open = subtractBusyIntervals(windows, busy);
    return splitIntoSlots(open, slotDurationMinutes);
  }

  /// Sessions that occupy the trainer for open-slot math: full scheduled seats
  /// plus in-progress/completed blocks. Cancelled and not-yet-full scheduled
  /// sessions are left out so empty PT seats remain matchable.
  static List<OpenSlot> busyIntervalsFromSessions(
    Iterable<ScheduleSession> sessions,
  ) {
    return sessions
        .where(_isBlockingBusy)
        .map((s) => OpenSlot(start: s.startTime, end: s.endTime))
        .toList();
  }

  static bool _isBlockingBusy(ScheduleSession s) {
    switch (s.status) {
      case ScheduleSessionStatus.ongoing:
      case ScheduleSessionStatus.completed:
        return true;
      case ScheduleSessionStatus.scheduled:
        return s.isFull;
      case ScheduleSessionStatus.cancelled:
        return false;
    }
  }

  /// True when [start]/[end] lies entirely inside at least one [window].
  static bool isContainedInWindows({
    required DateTime start,
    required DateTime end,
    required List<OpenSlot> windows,
  }) {
    for (final w in windows) {
      if (!start.isBefore(w.start) && !end.isAfter(w.end)) {
        return true;
      }
    }
    return false;
  }

  /// Bookable PT chips: scheduled, not-full sessions that fall inside
  /// availability − busy windows for their day.
  static List<BookableOpenSlot> matchBookableSessions({
    required List<TrainerAvailabilitySlot> availability,
    required List<ScheduleSession> sessions,
    String? trainerId,
  }) {
    final candidates = sessions.where((s) {
      if (s.status != ScheduleSessionStatus.scheduled || s.isFull) {
        return false;
      }
      if (trainerId != null && s.trainerId != trainerId) return false;
      return true;
    }).toList();

    final busyAll = busyIntervalsFromSessions(sessions);
    final result = <BookableOpenSlot>[];

    for (final session in candidates) {
      final dateIso = toDateIso(session.startTime);
      final dayStart = DateTime(
        session.startTime.year,
        session.startTime.month,
        session.startTime.day,
      );
      final dayEnd = dayStart.add(const Duration(days: 1));
      final dayBusy = busyAll
          .where(
            (b) => b.start.isBefore(dayEnd) && b.end.isAfter(dayStart),
          )
          .toList();
      // Exclude this session from busy so its own seat stays open.
      final busyExcludingSelf = dayBusy
          .where(
            (b) =>
                b.start != session.startTime || b.end != session.endTime,
          )
          .toList();

      final windows = buildDayAvailabilityWindows(
        dateIso: dateIso,
        availability: availability,
      );
      final open = subtractBusyIntervals(windows, busyExcludingSelf);
      if (isContainedInWindows(
        start: session.startTime,
        end: session.endTime,
        windows: open,
      )) {
        result.add(
          BookableOpenSlot(
            scheduleId: session.id,
            start: session.startTime,
            end: session.endTime,
            title: session.title,
          ),
        );
      }
    }

    result.sort((a, b) => a.start.compareTo(b.start));
    return result;
  }

  /// Convenience: compute fixed-duration open slots then keep sessions whose
  /// start/end exactly match a slot (millisecond equality).
  static List<BookableOpenSlot> matchSessionsToComputedSlots({
    required List<OpenSlot> openSlots,
    required List<ScheduleSession> sessions,
  }) {
    final slotKeys = {
      for (final s in openSlots) _slotKey(s.start, s.end),
    };
    final matched = <BookableOpenSlot>[];
    for (final session in sessions) {
      if (session.status != ScheduleSessionStatus.scheduled || session.isFull) {
        continue;
      }
      if (slotKeys.contains(_slotKey(session.startTime, session.endTime))) {
        matched.add(
          BookableOpenSlot(
            scheduleId: session.id,
            start: session.startTime,
            end: session.endTime,
            title: session.title,
          ),
        );
      }
    }
    matched.sort((a, b) => a.start.compareTo(b.start));
    return matched;
  }

  static String _slotKey(DateTime start, DateTime end) =>
      '${start.millisecondsSinceEpoch}:${end.millisecondsSinceEpoch}';
}
