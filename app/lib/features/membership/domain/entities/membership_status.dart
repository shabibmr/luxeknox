enum MembershipStatus { active, expired, frozen, cancelled }

enum FreezeStatus { pending, approved, rejected }

enum MembershipHistoryAction {
  created,
  renewed,
  upgraded,
  frozen,
  expired,
  cancelled,
  extended,
}
