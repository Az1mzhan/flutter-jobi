enum RoleType {
  worker,
  employer,
  entrepreneur,
  company,
  brigade,
  administrator,
}

extension RoleTypeX on RoleType {
  String get apiValue => switch (this) {
        RoleType.worker => 'worker',
        RoleType.employer => 'employer',
        RoleType.entrepreneur => 'entrepreneur',
        RoleType.company => 'company',
        RoleType.brigade => 'brigade',
        RoleType.administrator => 'administrator',
      };

  String get label => switch (this) {
        RoleType.worker => 'Worker',
        RoleType.employer => 'Employer',
        RoleType.entrepreneur => 'Individual entrepreneur',
        RoleType.company => 'Company',
        RoleType.brigade => 'Brigade',
        RoleType.administrator => 'Administrator',
      };

  String get shortLabel => switch (this) {
        RoleType.worker => 'Worker',
        RoleType.employer => 'Employer',
        RoleType.entrepreneur => 'IE',
        RoleType.company => 'Company',
        RoleType.brigade => 'Brigade',
        RoleType.administrator => 'Admin',
      };

  static RoleType fromString(String value) {
    return RoleType.values.firstWhere(
      (role) => role.apiValue == value,
      orElse: () => RoleType.worker,
    );
  }
}
