import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jobi/core/l10n/app_localizations.dart';
import 'package:jobi/core/widgets/state_views.dart';
import 'package:jobi/features/chat/presentation/cubit/chat_list_cubit.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<ChatListCubit>().state.status == ChatListStatus.initial) {
        context.read<ChatListCubit>().loadThreads();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<ChatListCubit, ChatListState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(l10n.text('chatTitle'))),
          body: SafeArea(
            child: Builder(
              builder: (context) {
                if (state.status == ChatListStatus.loading && state.threads.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.status == ChatListStatus.error && state.threads.isEmpty) {
                  return ErrorStateView(
                    message: state.message ?? l10n.text('networkError'),
                    onRetry: () => context.read<ChatListCubit>().loadThreads(),
                  );
                }

                if (state.threads.isEmpty) {
                  return EmptyStateView(
                    title: l10n.text('noConversationsYet'),
                    message: l10n.text('chatListHint'),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => context.read<ChatListCubit>().loadThreads(),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.threads.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final thread = state.threads[index];
                      return Card(
                        child: ListTile(
                          onTap: () => context.push('/chat/${thread.id}'),
                          leading: CircleAvatar(
                            child: Text(thread.title.substring(0, 1)),
                          ),
                          title: Text(thread.title),
                          subtitle: Text(
                            '${thread.lastMessagePreview}\n${thread.subtitle}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                DateFormat('HH:mm', l10n.localeName)
                                    .format(thread.lastMessageAt),
                              ),
                              if (thread.unreadCount > 0) ...[
                                const SizedBox(height: 6),
                                CircleAvatar(
                                  radius: 10,
                                  child: Text(
                                    '${thread.unreadCount}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ],
                          ),
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
