import 'package:flutter/widgets.dart';
import 'package:jobi/core/constants/user_roles.dart';
import 'package:jobi/core/l10n/app_localizations.dart';
import 'package:jobi/features/tasks/domain/entities/task.dart';

extension LocalizedRoleTypeX on RoleType {
  String localizedLabel(BuildContext context) {
    final l10n = context.l10n;
    return switch (this) {
      RoleType.worker => l10n.text('roleWorker'),
      RoleType.employer => l10n.text('roleEmployer'),
      RoleType.entrepreneur => l10n.text('roleEntrepreneur'),
      RoleType.company => l10n.text('roleCompany'),
      RoleType.brigade => l10n.text('roleBrigade'),
      RoleType.administrator => l10n.text('roleAdministrator'),
    };
  }

  String localizedShortLabel(BuildContext context) {
    final l10n = context.l10n;
    return switch (this) {
      RoleType.entrepreneur => l10n.text('roleEntrepreneurShort'),
      RoleType.administrator => l10n.text('roleAdministratorShort'),
      _ => localizedLabel(context),
    };
  }
}

extension LocalizedTaskStatusX on TaskStatus {
  String localizedLabel(BuildContext context) {
    final l10n = context.l10n;
    return switch (this) {
      TaskStatus.open => l10n.text('statusOpen'),
      TaskStatus.assigned => l10n.text('statusAssigned'),
      TaskStatus.inProgress => l10n.text('statusInProgress'),
      TaskStatus.completed => l10n.text('statusCompleted'),
      TaskStatus.cancelled => l10n.text('statusCancelled'),
      TaskStatus.rejected => l10n.text('statusRejected'),
    };
  }
}
