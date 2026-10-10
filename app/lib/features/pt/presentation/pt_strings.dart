abstract final class PtStrings {
  static const packagesTitle = 'PT Packages';
  static const newPackage = 'New PT package';
  static const editPackage = 'Edit PT package';
  static const noPackages = 'No PT packages yet.';
  static const name = 'Name';
  static const code = 'Code';
  static const description = 'Description';
  static const durationDays = 'Duration (days)';
  static const price = 'Price';
  static const taxPercentage = 'Tax %';
  static const active = 'Active';
  static const archived = 'Archived';
  static const save = 'Save';
  static const cancel = 'Cancel';
  static const saved = 'PT package saved';
  static const required = 'Required';
  static const invalidMoney = 'Use a two-decimal amount, e.g. 2999.00';
  static const invalidNumber = 'Enter a whole number';

  static const sellTitle = 'Add Personal Training';
  static const replanTitle = 'Change trainer / slot';
  static const stepPackage = 'Package & start date';
  static const stepDays = 'Training days';
  static const stepSlot = 'Trainer & hour';
  static const stepPay = 'Payment';
  static const stepConfirm = 'Confirm';
  static const next = 'Next';
  static const back = 'Back';
  static const startDate = 'Start date';
  static const effectiveFrom = 'Effective from';
  static const pickDaysHint = 'Choose which days this member will train.';
  static String daysChosen(int chosen) =>
      chosen == 1 ? '1 day chosen' : '$chosen days chosen';
  static const gridHint =
      'All active trainers are shown. A slot is free only if it is '
      'open on every training day of the whole period.';
  static const gridEmpty = 'No trainer has availability on these days.';
  static const free = 'Free';
  static const occupied = 'Occupied';
  static const unavailable = 'Unavailable';
  static const selected = 'Selected';
  static String clashes(int n) => n == 1 ? '1 clash' : '$n clashes';
  static const paymentMethod = 'Payment method';
  static const discount = 'Discount (optional)';
  static const noPaymentMethods =
      'No active payment methods — add one under Payments.';
  static const reason = 'Reason (optional)';
  static const confirmSell = 'Take payment & assign';
  static const confirmReplan = 'Apply change';
  static const summaryPackage = 'Package';
  static const summaryPeriod = 'Period';
  static const summaryDays = 'Days';
  static const summaryHour = 'Hour';
  static const summaryTrainer = 'Trainer';
  static const summaryAmount = 'Amount';
  static const sold = 'Personal Training assigned';
  static const replanned = 'Personal Training updated';

  static const renew = 'Renew PT';
  static const renewTitle = 'Renew Personal Training';
  static String renewBody(String trainer, String days, String hour) =>
      'Continue with $trainer on $days at $hour for another period, starting the day after the current end date.';
  static const renewed = 'Personal Training renewed';
  static const changeTrainerSlot = 'Change trainer / slot';
  static const readOnlyBanner =
      'Read-only: this member\'s Personal Training with you has ended. Renew PT to edit goals and plans.';
}
