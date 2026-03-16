import 'package:equatable/equatable.dart';

class ChatThread extends Equatable {
  const ChatThread({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.unreadCount,
    required this.lastMessagePreview,
    required this.lastMessageAt,
    required this.taskId,
    required this.isOnline,
  });

  final String id;
  final String title;
  final String subtitle;
  final int unreadCount;
  final String lastMessagePreview;
  final DateTime lastMessageAt;
  final String? taskId;
  final bool isOnline;

  @override
  List<Object?> get props => [
        id,
        title,
        subtitle,
        unreadCount,
        lastMessagePreview,
        lastMessageAt,
        taskId,
        isOnline,
      ];
}

class ChatMessage extends Equatable {
  const ChatMessage({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.imageUrl,
    required this.sentAt,
    required this.isMine,
    required this.isRead,
  });

  final String id;
  final String chatId;
  final String senderId;
  final String senderName;
  final String text;
  final String? imageUrl;
  final DateTime sentAt;
  final bool isMine;
  final bool isRead;

  @override
  List<Object?> get props => [
        id,
        chatId,
        senderId,
        senderName,
        text,
        imageUrl,
        sentAt,
        isMine,
        isRead,
      ];
}
