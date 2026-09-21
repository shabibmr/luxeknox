class MembershipStrings {
  MembershipStrings._();

  static const String catalogTitle = 'Membership Packages';
  static const String directoryTitle = 'Memberships';
  static const String detailTitle = 'Membership Details';
  static const String cardTitle = 'My Membership';
  static const String historyTitle = 'Membership History';
  static const String freezesTitle = 'Freeze Requests';
  static const String trainerSummaryTitle = 'Membership';

  static const String addTooltip = 'Add package';
  static const String editTitle = 'Edit Package';
  static const String addTitle = 'Add Package';
  static const String noPermission = 'You do not have permission to do this.';
  static const String noneFound = 'Nothing here yet.';
  static const String retry = 'Retry';
  static const String cancel = 'Cancel';
  static const String save = 'Save';
  static const String confirm = 'Confirm';

  static const String nameLabel = 'Name';
  static const String nameRequired = 'Name is required';
  static const String codeLabel = 'Code';
  static const String codeRequired = 'Code is required';
  static const String descriptionLabel = 'Description';
  static const String durationDaysLabel = 'Duration (days)';
  static const String durationDaysRequired = 'Duration is required';
  static const String basePriceLabel = 'Base price';
  static const String basePriceRequired = 'Base price is required';
  static const String taxPercentageLabel = 'Tax percentage';
  static const String maxFreezeDaysLabel = 'Max freeze days';
  static const String ptSessionsIncludedLabel = 'PT sessions included';
  static const String accessFacilitiesLabel = 'Access facilities';
  static const String commaSeparatedHelper = 'Comma-separated';
  static const String active = 'Active';
  static const String activeSubtitle = 'Visible in the sales catalog';

  static const String statusActive = 'Active';
  static const String statusExpired = 'Expired';
  static const String statusFrozen = 'Frozen';
  static const String statusCancelled = 'Cancelled';

  static const String filterAll = 'All';
  static const String filterActive = 'Active';
  static const String filterExpiringSoon = 'Expiring soon';
  static const String filterExpired = 'Expired';
  static const String filterFrozen = 'Frozen';
  static const String filterCancelled = 'Cancelled';

  static const String startDateLabel = 'Start date';
  static const String endDateLabel = 'End date';
  static const String remainingPtSessions = 'Remaining PT sessions';
  static const String lockerNumberLabel = 'Locker';
  static const String noActiveMembership = 'No active membership on file.';

  static const String renew = 'Renew';
  static const String upgrade = 'Upgrade';
  static const String cancelMembership = 'Cancel membership';
  static const String cancelConfirm =
      'This will cancel the membership. This does not process a refund.';
  static const String reasonLabel = 'Reason';
  static const String reasonRequired = 'A reason is required';

  static const String requestFreeze = 'Request freeze';
  static const String approve = 'Approve';
  static const String reject = 'Reject';
  static const String grantExtension = 'Grant extension';
  static const String daysExtendedLabel = 'Days to extend';
  static const String daysExtendedRequired = 'Enter a number of days';

  static String rowVersionConflict(String action) =>
      'This membership changed since you loaded it. Refresh and retry the $action.';
}
