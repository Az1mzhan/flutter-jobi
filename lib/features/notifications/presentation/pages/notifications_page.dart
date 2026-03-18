import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jobi/core/l10n/app_localizations.dart';
import 'package:jobi/core/widgets/state_views.dart';
import 'package:jobi/features/notifications/presentation/cubit/notifications_cubit.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<NotificationsCubit>().state.status ==
          NotificationsStatus.initial) {
        context.read<NotificationsCubit>().loadNotifications();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(l10n.text('notificationsTitle'))),
          body: SafeArea(
            child: Builder(
              builder: (context) {
                if (state.status == NotificationsStatus.loading &&
                    state.notifications.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.status == NotificationsStatus.error &&
                    state.notifications.isEmpty) {
                  return ErrorStateView(
                    message: state.message ?? l10n.text('networkError'),
                    onRetry: () => context.read<NotificationsCubit>().loadNotifications(),
                  );
                }

                if (state.notifications.isEmpty) {
                  return EmptyStateView(
                    title: l10n.text('allCaughtUp'),
                    message: l10n.text('notificationsEmptyHint'),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => context.read<NotificationsCubit>().loadNotifications(),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.notifications.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final notification = state.notifications[index];
                      return Card(
                        color: notification.isRead
                            ? null
                            : Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.08),
                        child: ListTile(
                          onTap: () async {
                            await context
                                .read<NotificationsCubit>()
                                .markRead(notification.id);
                            if (context.mounted) {
                              context.push(notification.route);
                            }
                          },
                          title: Text(notification.title),
                          subtitle: Text(
                            '${notification.body}\n${DateFormat('d MMM • HH:mm', l10n.localeName).format(notification.createdAt)}',
                          ),
                          trailing: notification.isRead
                              ? const Icon(Icons.done_all_rounded)
                              : const Icon(Icons.fiber_manual_record, size: 12),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
