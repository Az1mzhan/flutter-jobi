import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jobi/core/l10n/app_localizations.dart';
import 'package:jobi/core/l10n/enum_localizations.dart';
import 'package:jobi/core/widgets/state_views.dart';
import 'package:jobi/features/tasks/domain/entities/task.dart';
import 'package:jobi/features/tasks/presentation/cubit/tasks_cubit.dart';
import 'package:jobi/features/tasks/presentation/widgets/task_card.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<TasksCubit>().state.status == TasksStatus.initial) {
        context.read<TasksCubit>().loadTasks();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<TasksCubit, TasksState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(l10n.text('tasksTitle'))),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => context.push('/tasks/create'),
            icon: const Icon(Icons.add_rounded),
            label: Text(l10n.text('createTask')),
          ),
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 56,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _FilterChip(
                        label: l10n.text('all'),
                        selected: state.filter == null,
                        onTap: () =>
                            context.read<TasksCubit>().loadTasks(clearFilter: true),
                      ),
                      ...TaskStatus.values.map(
                        (status) => _FilterChip(
                          label: status.localizedLabel(context),
                          selected: state.filter == status,
                          onTap: () => context.read<TasksCubit>().loadTasks(filter: status),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (state.status == TasksStatus.loading && state.tasks.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state.status == TasksStatus.error && state.tasks.isEmpty) {
                        return ErrorStateView(
                          message: state.message ?? l10n.text('networkError'),
                          onRetry: () => context.read<TasksCubit>().loadTasks(),
                        );
                      }

                      if (state.tasks.isEmpty) {
                        return EmptyStateView(
                          title: l10n.text('noTasksYet'),
                          message: l10n.text('noTasksHint'),
                          actionLabel: l10n.text('createTask'),
                          onAction: () => context.push('/tasks/create'),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () =>
                            context.read<TasksCubit>().loadTasks(filter: state.filter),
                        child: ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: state.tasks.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final task = state.tasks[index];
                            return TaskCard(
                              task: task,
                              onTap: () => context.push('/tasks/${task.id}'),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
      ),
    );
  }
}
