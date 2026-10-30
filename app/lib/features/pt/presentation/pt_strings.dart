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
  static const packageTypeLabel = 'Package type';
  static const packageTypeSingle = 'Single';
  static const packageTypeCouple = 'Couple';
  static const coupleChip = packageTypeCouple;
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
  static const paymentDate = 'Payment date';
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
  static const summaryDiscount = 'Discount';
  static const summaryTax = 'Tax';
  static const summaryTotal = 'Total';
  static const sold = 'Personal Training assigned';
  static const replanned = 'Personal Training updated';

  static const partnerLabel = 'Partner (second member)';
  static const partnerHint = 'Select partner';
  static const partnerChecking = 'Checking partner…';
  static const coupleTotalNote = 'Total for both members';
  static const membershipIncluded =
      'Includes a gym membership for the same period. An existing membership is extended.';
  static const membershipIncludedCouple =
      'Includes a gym membership for each member for the same period. Existing memberships are extended.';
  static const replanCoupleNote = 'This change applies to both members.';
  static String partnerHasOpenPt(String name, String until) =>
      '$name already has PT until $until';
  static const partnerSameAsMember = 'Partner must be a different member';

  static const renew = 'Renew PT';
  static const renewTitle = 'Renew Personal Training';
  static String renewBody(String trainer, String days, String hour) =>
      'Continue with $trainer on $days at $hour for another period, starting the day after the current end date. The gym membership is extended by the same period.';
  static const renewed = 'Personal Training renewed';
  static const changeTrainerSlot = 'Change trainer / slot';
  static const readOnlyBanner =
      'Read-only: this member\'s Personal Training with you has ended. Renew PT to edit goals and plans.';

  static const progressReviewTitle = 'Progress review';
  static const reviewPeriod = 'Review period';
  static const periodStart = 'Period start';
  static const periodEnd = 'Period end';
  static const measuresTitle = 'Measures';
  static const measureColumn = 'Measure';
  static const startColumn = 'Start';
  static const currentColumn = 'Current';
  static const changeColumn = 'Change';
  static const targetColumn = 'Target';
  static const noMeasures = 'No measures recorded.';
  static const highlightsTitle = 'Celebration highlights';
  static const noHighlights = 'No celebration highlights yet.';
  static const checklistTitle = 'Discussed';
  static const goalsReviewed = 'Goals reviewed';
  static const measurementsReviewed = 'Measurements reviewed';
  static const performanceReviewed = 'Performance reviewed';
  static const attendanceReviewed = 'Attendance reviewed';
  static const programUpdated = 'Program updated';
  static const nextGoalsAgreed = 'Next goals agreed';
  static const roadmapTitle = 'Next phase';
  static const nextPhaseGoal = 'Next goal';
  static const nextPhaseFocus = 'Training focus';
  static const nextReviewDate = 'Next review date';
  static const notSet = 'Not set';
  static const emptyValue = '—';
  static const signoffTitle = 'Sign-off';
  static const trainerParty = 'Trainer';
  static const clientParty = 'Client';
  static const managerParty = 'Manager';
  static const pending = 'Pending';
  static const signAsTrainer = 'Sign as trainer';
  static const signAsClient = 'Sign as client';
  static const approveReview = 'Approve review';
  static const exportPdf = 'Export PDF Presentation Card';
  static const createDraft = 'Create draft';
  static const trainerSummary = 'Trainer summary';
  static const clientFeedback = 'Client feedback';
  static const statusDraft = 'Draft';
  static const statusClient = 'Waiting for client';
  static const statusManager = 'Waiting for manager';
  static const statusApproved = 'Approved';
  static const statusArchived = 'Archived';
  static const drafted = 'Review draft saved';
  static const trainerSigned = 'Trainer signed';
  static const clientSigned = 'Client signed';
  static const managerApproved = 'Manager approved';
  static const exported = 'Presentation card exported';
  static const reviewLoadFailed = 'Could not load this progress review.';
  static const reviewMissing = 'Open a progress review to continue.';
}
