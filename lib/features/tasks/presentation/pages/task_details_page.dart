import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jobi/core/widgets/state_views.dart';
import 'package:jobi/features/tasks/domain/entities/task.dart';
import 'package:jobi/features/tasks/presentation/cubit/tasks_cubit.dart';
import 'package:jobi/features/tasks/presentation/widgets/task_status_chip.dart';

class TaskDetailsPage extends StatefulWidget {
  const TaskDetailsPage({super.key, required this.taskId});

  final String taskId;

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TasksCubit>().openTask(widget.taskId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksCubit, TasksState>(
      builder: (context, state) {
        final task = state.selectedTask;
        if (state.status == TasksStatus.loading && task == null) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (state.status == TasksStatus.error && task == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Task details')),
            body: ErrorStateView(
              message: state.message ?? 'Unable to load task details.',
              onRetry: () => context.read<TasksCubit>().openTask(widget.taskId),
            ),
          );
        }

        if (task == null) {
          return const Scaffold(
            body: EmptyStateView(
              title: 'Task not found',
              message: 'This task is missing from the current demo state.',
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Task details')),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                task.professionName,
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                            ),
                            TaskStatusChip(status: task.status),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(task.description),
                        const SizedBox(height: 18),
                        _DetailRow(
                          icon: Icons.location_on_outlined,
                          label: '${task.locationName}, ${task.cityName}',
                        ),
                        _DetailRow(
                          icon: Icons.payments_outlined,
                          label: '${task.price.toInt()} KZT',
                        ),
                        _DetailRow(
                          icon: Icons.schedule_rounded,
                          label: DateFormat('d MMM yyyy · HH:mm').format(task.startTime),
                        ),
                        _DetailRow(
                          icon: Icons.timer_outlined,
                          label: '${task.durationHours} hour(s)',
                        ),
                        _DetailRow(
                          icon: Icons.business_center_outlined,
                          label: task.employerName,
                        ),
                        if (task.workerName != null)
                          _DetailRow(
                            icon: Icons.person_outline_rounded,
                            label: task.workerName!,
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status timeline',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        ...TaskStatus.values.map(
                          (status) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              radius: 14,
                              child: Icon(
                                _statusIndex(task.status) >= _statusIndex(status)
                                    ? Icons.check_rounded
                                    : Icons.circle_outlined,
                                size: 16,
                              ),
                            ),
                            title: Text(status.label),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Map-ready placeholder',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        Container(
                          height: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Reserved for map integration',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            minimum: const EdgeInsets.all(16),
            child: Row(
              children: _actionButtons(context, task),
            ),
          ),
        );
      },
    );
  }

  int _statusIndex(TaskStatus status) {
    return switch (status) {
      TaskStatus.open => 0,
      TaskStatus.assigned => 1,
      TaskStatus.inProgress => 2,
      TaskStatus.completed => 3,
      TaskStatus.cancelled => 4,
      TaskStatus.rejected => 4,
    };
  }

  List<Widget> _actionButtons(BuildContext context, TaskEntity task) {
    final cubit = context.read<TasksCubit>();
    switch (task.status) {
      case TaskStatus.open:
        return [
          Expanded(
            child: ElevatedButton(
              onPressed: () =>
                  cubit.changeStatus(taskId: task.id, status: TaskStatus.assigned),
              child: const Text('Accept / assign'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton(
              onPressed: () =>
                  cubit.changeStatus(taskId: task.id, status: TaskStatus.rejected),
              child: const Text('Reject'),
            ),
          ),
        ];
      case TaskStatus.assigned:
        return [
          Expanded(
            child: ElevatedButton(
              onPressed: () =>
                  cubit.changeStatus(taskId: task.id, status: TaskStatus.inProgress),
              child: const Text('Start work'),
            ),
          ),
        ];
      case TaskStatus.inProgress:
        return [
          Expanded(
            child: ElevatedButton(
              onPressed: () =>
                  cubit.changeStatus(taskId: task.id, status: TaskStatus.completed),
              child: const Text('Mark completed'),
            ),
          ),
        ];
      case TaskStatus.completed:
      case TaskStatus.cancelled:
      case TaskStatus.rejected:
        return [
          const Expanded(
            child: OutlinedButton(
              onPressed: null,
              child: Text('No further actions'),
            ),
          ),
        ];
    }
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 10),
          Expanded(child: Text(label)),
        ],
      ),
    );
  }
}
