import 'dart:async';

import 'package:jobi/features/chat/data/models/chat_models.dart';

abstract class ChatSocketService {
  Future<void> connect(String threadId);

  Future<void> disconnect(String threadId);

  Stream<ChatMessageModel> stream(String threadId);

  Future<void> scheduleReply({
    required String threadId,
    required String senderName,
    required String replyText,
  });
}

class MockChatSocketService implements ChatSocketService {
  final Map<String, StreamController<ChatMessageModel>> _controllers = {};

  StreamController<ChatMessageModel> _controllerFor(String threadId) {
    return _controllers.putIfAbsent(
      threadId,
      () => StreamController<ChatMessageModel>.broadcast(),
    );
  }

  @override
  Future<void> connect(String threadId) async {}

  @override
  Future<void> disconnect(String threadId) async {}

  @override
  Stream<ChatMessageModel> stream(String threadId) => _controllerFor(threadId).stream;

  @override
  Future<void> scheduleReply({
    required String threadId,
    required String senderName,
    required String replyText,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    _controllerFor(threadId).add(
      ChatMessageModel(
        id: 'reply_${DateTime.now().millisecondsSinceEpoch}',
        chatId: threadId,
        senderId: 'peer_$threadId',
        senderName: senderName,
        text: replyText,
        imageUrl: null,
        sentAt: DateTime.now(),
        isMine: false,
        isRead: false,
      ),
    );
  }
}
