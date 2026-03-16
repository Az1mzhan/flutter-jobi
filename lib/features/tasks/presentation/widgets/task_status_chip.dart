import 'package:flutter/material.dart';
import 'package:jobi/core/theme/app_colors.dart';
import 'package:jobi/features/tasks/domain/entities/task.dart';

class TaskStatusChip extends StatelessWidget {
  const TaskStatusChip({super.key, required this.status});

  final TaskStatus status;

  Color _backgroundColor() {
    return switch (status) {
      TaskStatus.open => AppColors.info.withOpacity(0.14),
      TaskStatus.assigned => AppColors.warning.withOpacity(0.18),
      TaskStatus.inProgress => AppColors.brand.withOpacity(0.18),
      TaskStatus.completed => AppColors.success.withOpacity(0.14),
      TaskStatus.cancelled => AppColors.danger.withOpacity(0.14),
      TaskStatus.rejected => AppColors.danger.withOpacity(0.14),
    };
  }

  Color _foregroundColor() {
    return switch (status) {
      TaskStatus.open => AppColors.info,
      TaskStatus.assigned => AppColors.warning,
      TaskStatus.inProgress => AppColors.brand,
      TaskStatus.completed => AppColors.success,
      TaskStatus.cancelled => AppColors.danger,
      TaskStatus.rejected => AppColors.danger,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _backgroundColor(),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: _foregroundColor(),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
