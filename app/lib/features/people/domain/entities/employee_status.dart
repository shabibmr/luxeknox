enum EmployeeStatus {
  active,
  onProbation,
  suspended,
  terminated;

  String get wire => switch (this) {
    EmployeeStatus.active => 'active',
    EmployeeStatus.onProbation => 'on_probation',
    EmployeeStatus.suspended => 'suspended',
    EmployeeStatus.terminated => 'terminated',
  };

  static EmployeeStatus fromWire(String? value) {
    return switch (value) {
      'active' => EmployeeStatus.active,
      'on_probation' || 'onProbation' => EmployeeStatus.onProbation,
      'suspended' => EmployeeStatus.suspended,
      'terminated' => EmployeeStatus.terminated,
      _ => EmployeeStatus.active,
    };
  }
}
