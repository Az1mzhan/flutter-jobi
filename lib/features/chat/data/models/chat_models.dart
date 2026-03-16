import 'package:jobi/features/chat/domain/entities/chat_entities.dart';

class ChatThreadModel extends ChatThread {
  const ChatThreadModel({
    required super.id,
    required super.title,
    required super.subtitle,
    required super.unreadCount,
    required super.lastMessagePreview,
    required super.lastMessageAt,
    required super.taskId,
    required super.isOnline,
  });

  factory ChatThreadModel.fromJson(Map<String, dynamic> json) {
    return ChatThreadModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      unreadCount: json['unreadCount'] as int? ?? 0,
      lastMessagePreview: json['lastMessagePreview'] as String? ?? '',
      lastMessageAt: DateTime.tryParse(json['lastMessageAt'] as String? ?? '') ??
          DateTime.now(),
      taskId: json['taskId'] as String?,
      isOnline: json['isOnline'] as bool? ?? false,
    );
  }
}

class ChatMessageModel extends ChatMessage {
  const ChatMessageModel({
    required super.id,
    required super.chatId,
    required super.senderId,
    required super.senderName,
    required super.text,
    required super.imageUrl,
    required super.sentAt,
    required super.isMine,
    required super.isRead,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as String? ?? '',
      chatId: json['chatId'] as String? ?? '',
      senderId: json['senderId'] as String? ?? '',
      senderName: json['senderName'] as String? ?? '',
      text: json['text'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      sentAt: DateTime.tryParse(json['sentAt'] as String? ?? '') ?? DateTime.now(),
      isMine: json['isMine'] as bool? ?? false,
      isRead: json['isRead'] as bool? ?? false,
    );
  }
}
