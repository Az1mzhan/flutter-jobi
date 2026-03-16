import 'package:jobi/features/chat/domain/entities/chat_entities.dart';

abstract class ChatRepository {
  Future<List<ChatThread>> getThreads();

  Future<List<ChatMessage>> getMessages(String threadId);

  Future<void> connect(String threadId);

  Future<void> disconnect(String threadId);

  Stream<ChatMessage> incomingMessages(String threadId);

  Future<ChatMessage> sendText({
    required String threadId,
    required String text,
  });

  Future<ChatMessage> sendImagePlaceholder({required String threadId});
}
