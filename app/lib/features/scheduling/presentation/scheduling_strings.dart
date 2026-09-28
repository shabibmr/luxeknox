class SchedulingStrings {
  SchedulingStrings._();

  static const String calendarTitle = 'Schedule';
  static const String detailTitle = 'Session';
  static const String facilitiesTitle = 'Facilities';
  static const String availabilityTitle = 'My availability';
  static const String bookPtTitle = 'Book PT';
  static const String bookClassTitle = 'Book class';
  static const String retry = 'Retry';
  static const String noneFound = 'No sessions in this range.';
  static const String historyTitle = 'Schedule history';
  static const String historyEmpty = 'No past sessions yet.';
  static const String todaysSessionsTitle = "Today's sessions";
  static const String todaysSessionsEmpty = 'No sessions scheduled for today.';
  static const String book = 'Book';
  static const String cancelSession = 'Cancel session';
  static const String startSession = 'Start';
  static const String completeSession = 'Complete';
  static const String leaveWaitlist = 'Leave waitlist';
  static const String unbook = 'Cancel booking';
  static const String roster = 'Roster';
  static const String waitlist = 'Waitlist';
  static const String submitting = 'Working…';
  static const String facilitiesEmpty = 'No facilities yet.';
  static const String availabilityEmpty = 'No availability slots.';
  static const String addFacility = 'Add facility';
  static const String facilityNameLabel = 'Name';
  static const String capacityLabel = 'Capacity';
  static const String bookSuccess = 'Booked';
  static const String waitlistedSuccess = 'Added to waitlist';
  static const String doubleSubmitBlocked = 'Request already in progress.';

  // Schedule form field widgets (F2).
  static const String trainerFieldLabel = 'Trainer';
  static const String trainerFieldPlaceholder = 'Select a trainer';
  static const String trainerSearchHint = 'Search trainers';
  static const String trainerFieldEmpty = 'No trainers found.';
  static const String facilityFieldLabel = 'Facility';
  static const String facilityFieldPlaceholder = 'Select a facility';
  static const String facilityFieldEmpty = 'No facilities available.';
  static const String scheduleTypeFieldLabel = 'Session type';
  static const String scheduleTypeFieldPlaceholder = 'Select a session type';
  static const String scheduleTypeFieldEmpty = 'No session types available.';
  static const String startTimeLabel = 'Starts';
  static const String endTimeLabel = 'Ends';
  static const String dateTimePlaceholder = 'Select date & time';
  static const String endBeforeStartError = 'End time must be after start time.';
  static const String requiredFieldError = 'Required';
  static const String capacityInvalidError = 'Capacity must be greater than 0.';
  static const String loadFailedRetry = 'Couldn\'t load. Tap to retry.';

  // Reschedule / move booking (P3).
  static const String reschedule = 'Reschedule';
  static const String rescheduleTitle = 'Reschedule session';
  static const String rescheduleSubmit = 'Save new time';
  static const String rescheduleSuccess = 'Session rescheduled.';
  static const String rowVersionConflict =
      'This session changed since you opened it. Reloaded — review the times and try again.';
  static const String retryReschedule = 'Retry';
  static const String moveBooking = 'Move booking';
  static const String moveBookingTitle = 'Move to another session';
  static const String moveBookingEmpty =
      'No other sessions of this type are available.';
  static const String moveBookingSubmit = 'Move here';
  static const String moveBookingSuccess = 'Booking moved.';
  static const String moveBookingCapBlocked =
      'You are at your booking limit. Cancel another booking before moving.';
  static const String moveBookingCancelFailed =
      'Booked the new session, but could not cancel the old one. Check both sessions.';
  static const String moveBookingLoadFailed =
      'Could not load alternative sessions.';

  // Admin Schedule Form (M4).
  static const String createScheduleTitle = 'Create schedule';
  static const String editScheduleTitle = 'Edit schedule';
  static const String titleLabel = 'Title';
  static const String titlePlaceholder = 'e.g. Morning Yoga';
  static const String notesLabel = 'Notes';
  static const String notesPlaceholder = 'Optional instructions or details';
  static const String createScheduleSubmit = 'Create session';
  static const String updateScheduleSubmit = 'Update session';
  static const String scheduleCreatedSuccess = 'Schedule created.';
  static const String scheduleUpdatedSuccess = 'Schedule updated.';
  static const String unsavedChangesTitle = 'Unsaved changes';
  static const String unsavedChangesMessage =
      'You have unsaved changes. Are you sure you want to discard them?';
  static const String discard = 'Discard';

  // Recurring series (M5).
  static const String recurringSeries = 'Recurring series';
  static const String repeatUntilLabel = 'Repeat weekly until';
  static const String repeatUntilPlaceholder = 'Select end date (optional)';
  static const String recurUntilBeforeStartError =
      'Repeat until date must be on or after start date.';
  static const String editRecurringTitle = 'Edit recurring session';
  static const String editRecurringMessage =
      'This session is part of a recurring series. What would you like to edit?';
  static const String editThisSessionOnly = 'This session only';
  static const String editWholeSeries = 'Whole series';
  static const String editSeriesNotSupported =
      'Series-wide editing is not supported yet. Please edit individual occurrences.';
  static const String cancelRecurringTitle = 'Cancel recurring session';
  static const String cancelRecurringMessage =
      'This session is part of a recurring series. What would you like to cancel?';
  static const String cancelThisSessionOnly = 'This session only';
  static const String cancelAllFutureSessions = 'All future sessions in series';

  // Open slots / PT book (M6).
  static const String openSlotsTrainerLabel = 'Your trainer';
  static const String openSlotsNoTrainer =
      'No trainer assigned. Ask the front desk to assign one before booking PT.';
  static const String openSlotsEmptyDay = 'No open slots on this day.';
  static const String openSlotsEmptyRange =
      'No open PT slots in the next two weeks.';
  static const String openSlotsStale =
      'That slot was just taken. Showing updated availability.';
  static const String openSlotsBook = 'Book this slot';
  static const String openSlotsSelectPrompt = 'Pick a day and time slot.';
}

