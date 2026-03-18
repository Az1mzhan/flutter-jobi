import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobi/core/l10n/app_localizations.dart';
import 'package:jobi/features/chat/domain/entities/chat_entities.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isMine = message.isMine;
    final bubbleColor = isMine
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.surfaceContainerHighest;
    final textColor = isMine ? Colors.white : Theme.of(context).colorScheme.onSurface;
    final statusLabel = isMine
        ? (message.isRead ? l10n.text('read') : l10n.text('sent'))
        : null;

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 280),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment:
                isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              if (message.imageUrl != null)
                Container(
                  height: 140,
                  width: 220,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.image_outlined,
                    size: 34,
                    color: isMine ? Colors.white70 : null,
                  ),
                ),
              if (message.text.isNotEmpty)
                Text(
                  message.text,
                  style: TextStyle(color: textColor),
                ),
              const SizedBox(height: 6),
              Text(
                '${DateFormat('HH:mm', l10n.localeName).format(message.sentAt)}${statusLabel == null ? '' : ' • $statusLabel'}',
                style: TextStyle(
                  color: textColor.withValues(alpha: 0.8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
