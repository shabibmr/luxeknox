enum BroadcastAudience {
  allMembers,
  assignedClients,
  role;

  String get wireName => switch (this) {
    BroadcastAudience.allMembers => 'all_members',
    BroadcastAudience.assignedClients => 'assigned_clients',
    BroadcastAudience.role => 'role',
  };

  static BroadcastAudience fromWire(String raw) {
    final normalized = raw.trim().toLowerCase();
    return switch (normalized) {
      'all_members' || 'allmembers' => BroadcastAudience.allMembers,
      'assigned_clients' || 'assignedclients' =>
        BroadcastAudience.assignedClients,
      'role' => BroadcastAudience.role,
      _ => BroadcastAudience.allMembers,
    };
  }
}
