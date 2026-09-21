enum ScheduleSessionStatus { scheduled, ongoing, completed, cancelled }

ScheduleSessionStatus scheduleSessionStatusFromName(String name) {
  return switch (name) {
    'ongoing' => ScheduleSessionStatus.ongoing,
    'completed' => ScheduleSessionStatus.completed,
    'cancelled' => ScheduleSessionStatus.cancelled,
    _ => ScheduleSessionStatus.scheduled,
  };
}

enum BookingStatus { booked, waitlisted, cancelled }

BookingStatus bookingStatusFromName(String name) {
  return switch (name) {
    'waitlisted' => BookingStatus.waitlisted,
    'cancelled' => BookingStatus.cancelled,
    _ => BookingStatus.booked,
  };
}
