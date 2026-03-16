import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';
import 'package:jobi/core/widgets/state_views.dart';
import 'package:jobi/features/chat/presentation/cubit/chat_detail_cubit.dart';
import 'package:jobi/features/chat/presentation/cubit/chat_list_cubit.dart';
import 'package:jobi/features/chat/presentation/widgets/message_bubble.dart';

class ChatDetailPage extends StatefulWidget {
  const ChatDetailPage({super.key, required this.threadId});

  final String threadId;

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatDetailCubit>().openThread(widget.threadId);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    context.read<ChatDetailCubit>().closeThread();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final thread = context
        .watch<ChatListCubit>()
        .state
        .threads
        .where((item) => item.id == widget.threadId)
        .firstOrNull;

    return BlocBuilder<ChatDetailCubit, ChatDetailState>(
      builder: (context, state) {
        if (state.status == ChatDetailStatus.loading && state.messages.isEmpty) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (state.status == ChatDetailStatus.error && state.messages.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: Text(thread?.title ?? 'Chat')),
            body: ErrorStateView(
              message: state.message ?? 'Unable to open chat',
              onRetry: () => context.read<ChatDetailCubit>().openThread(widget.threadId),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(thread?.title ?? 'Chat'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(28),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  state.isConnected ? 'Connected' : 'Reconnecting...',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: state.messages.isEmpty
                      ? const EmptyStateView(
                          title: 'No messages yet',
                          message: 'Start the conversation to coordinate the job.',
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: state.messages.length,
                          itemBuilder: (context, index) {
                            return MessageBubble(message: state.messages[index]);
                          },
                        ),
                ),
                if (state.status == ChatDetailStatus.error && state.message != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        state.message!,
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () =>
                            context.read<ChatDetailCubit>().sendImagePlaceholder(),
                        icon: const Icon(Icons.image_outlined),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          minLines: 1,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            hintText: 'Write a message',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        onPressed: () {
                          final text = _messageController.text;
                          _messageController.clear();
                          context.read<ChatDetailCubit>().sendText(text);
                        },
                        icon: const Icon(Icons.send_rounded),
                      ),
                    ],
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
