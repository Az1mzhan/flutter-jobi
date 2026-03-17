import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jobi/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:jobi/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:jobi/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:jobi/features/tasks/presentation/cubit/tasks_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileCubit = context.read<ProfileCubit>();
      final notificationsCubit = context.read<NotificationsCubit>();
      final tasksCubit = context.read<TasksCubit>();

      if (profileCubit.state.profile == null) {
        profileCubit.loadProfile();
      }
      if (notificationsCubit.state.status == NotificationsStatus.initial) {
        notificationsCubit.loadNotifications();
      }
      if (tasksCubit.state.status == TasksStatus.initial) {
        tasksCubit.loadTasks();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('JOBI'),
        actions: [
          IconButton(
            onPressed: () => context.push('/notifications'),
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                final name = authState.session?.fullName ?? 'Welcome';
                final role = authState.activeRole?.label ?? 'Member';
                return Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.primary.withValues(alpha: 0.72),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, $name',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Current role: $role',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          FilledButton.tonal(
                            onPressed: () => context.go('/search'),
                            child: const Text('Explore nearby'),
                          ),
                          FilledButton.tonal(
                            onPressed: () => context.push('/tasks/create'),
                            child: const Text('Post a task'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                final profile = state.profile;
                return Row(
                  children: [
                    Expanded(
                      child: _DashboardCard(
                        label: 'Rating',
                        value: profile?.rating.toStringAsFixed(1) ?? '--',
                        icon: Icons.star_rounded,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DashboardCard(
                        label: 'Successful jobs',
                        value: profile?.successfulTasks.toString() ?? '--',
                        icon: Icons.verified_rounded,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 12),
            BlocBuilder<TasksCubit, TasksState>(
              builder: (context, state) {
                final openTasks = state.tasks.where((task) => task.status.name == 'open').length;
                return Row(
                  children: [
                    Expanded(
                      child: _DashboardCard(
                        label: 'Open tasks',
                        value: '$openTasks',
                        icon: Icons.assignment_outlined,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: BlocBuilder<NotificationsCubit, NotificationsState>(
                        builder: (context, notificationState) {
                          final unread = notificationState.notifications
                              .where((item) => !item.isRead)
                              .length;
                          return _DashboardCard(
                            label: 'Unread alerts',
                            value: '$unread',
                            icon: Icons.notifications_active_outlined,
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick actions',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () => context.push('/brigades'),
                          icon: const Icon(Icons.groups_2_outlined),
                          label: const Text('Brigades'),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => context.push('/profile/history'),
                          icon: const Icon(Icons.insights_outlined),
                          label: const Text('Ratings & history'),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => context.go('/chat'),
                          icon: const Icon(Icons.chat_bubble_outline_rounded),
                          label: const Text('Messages'),
                        ),
                      ],
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
                      'Geo hiring flow',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Use Search for radius, district, city, region, or whole-country discovery. The current architecture is ready for a map screen when the geo backend is finalized.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 4),
            Text(label),
          ],
        ),
      ),
    );
  }
}
