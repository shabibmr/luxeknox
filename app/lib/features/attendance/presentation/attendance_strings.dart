abstract final class AttendanceStrings {
  static const passTitle = 'Digital pass';
  static const historyTitle = 'Attendance history';
  static const summaryTitle = 'Attendance summary';
  static const adminTitle = 'Attendance';
  static const liveFeed = 'Live feed';
  static const manualOverride = 'Manual check-in';
  static const scanQr = 'Scan QR';
  static const refreshPass = 'Refresh pass';
  static const passExpired = 'Pass expired — refresh to get a new code';
  static const expiresAt = 'Expires';
  static const checkOut = 'Check out';
  static const checkInSuccess = 'Checked in';
  static const checkOutSuccess = 'Checked out';
  static const doubleSubmitBlocked = 'Already submitting — please wait';
  static const submitting = 'Submitting…';
  static const streak = 'Streak (days)';
  static const visitsMonth = 'Visits this month';
  static const lastCheckIn = 'Last check-in';
  static const heatmap = 'Visit heatmap';
  static const footfall = 'Gym footfall';
  static const emptyHistory = 'No check-ins yet';
  static const emptyFeed = 'No check-ins in this range';
  static const userIdLabel = 'Member user id';
  static const gateLabel = 'Gate (optional)';
  static const payloadLabel = 'Pass payload';
  static const markAttended = 'Attended';
  static const markNoShow = 'No-show';
  static const cameraPermissionDenied =
      'Camera permission denied. Enable camera access to scan member passes, or enter the payload manually.';
  static const cameraUnavailable =
      'Camera unavailable. Enter the pass payload manually to check in.';
  static const openSession = 'Currently checked in';
  static const summaryLink = 'Summary & streak';
  static const historyLink = 'Full history';
  static const liveOccupancy = 'Live occupancy';
  static const checkedInNow = 'checked in now';
  static const occupancyLoadFailed = 'Could not load live occupancy';
  static String asOf(String time) => 'As of $time';
}
