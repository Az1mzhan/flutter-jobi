import 'package:jobi/core/constants/app_constants.dart';
import 'package:jobi/features/chat/data/datasources/chat_socket_service.dart';
import 'package:jobi/features/chat/data/models/chat_models.dart';

class ChatMockDataSource {
  ChatMockDataSource() : _socketService = MockChatSocketService() {
    _threads = [
      ChatThreadModel(
        id: 'chat_1',
        title: 'Khan Stroy LLP',
        subtitle: 'Task-based chat',
        unreadCount: 2,
        lastMessagePreview: 'Can your brigade start this evening?',
        lastMessageAt: DateTime.now().subtract(const Duration(minutes: 14)),
        taskId: 'task_1',
        isOnline: true,
      ),
      ChatThreadModel(
        id: 'chat_2',
        title: 'Dias R.',
        subtitle: 'Direct chat',
        unreadCount: 0,
        lastMessagePreview: 'I will share the exact address soon.',
        lastMessageAt: DateTime.now().subtract(const Duration(hours: 3)),
        taskId: null,
        isOnline: false,
      ),
    ];

    _messages = {
      'chat_1': [
        ChatMessageModel(
          id: 'm1',
          chatId: 'chat_1',
          senderId: 'peer_1',
          senderName: 'Khan Stroy LLP',
          text: 'Can your brigade start this evening?',
          imageUrl: null,
          sentAt: DateTime.now().subtract(const Duration(minutes: 20)),
          isMine: false,
          isRead: true,
        ),
        ChatMessageModel(
          id: 'm2',
          chatId: 'chat_1',
          senderId: 'me',
          senderName: 'Me',
          text: 'Yes, two painters are available after 18:00.',
          imageUrl: null,
          sentAt: DateTime.now().subtract(const Duration(minutes: 16)),
          isMine: true,
          isRead: true,
        ),
      ],
      'chat_2': [
        ChatMessageModel(
          id: 'm3',
          chatId: 'chat_2',
          senderId: 'peer_2',
          senderName: 'Dias R.',
          text: 'I will share the exact address soon.',
          imageUrl: null,
          sentAt: DateTime.now().subtract(const Duration(hours: 3)),
          isMine: false,
          isRead: true,
        ),
      ],
    };
  }

  late final List<ChatThreadModel> _threads;
  late final Map<String, List<ChatMessageModel>> _messages;
  final ChatSocketService _socketService;

  Future<List<ChatThreadModel>> getThreads() async {
    await Future<void>.delayed(AppConstants.mockDelay);
    _threads.sort((a, b) => b.lastMessageAt.compareTo(a.lastMessageAt));
    return List<ChatThreadModel>.from(_threads);
  }

  Future<List<ChatMessageModel>> getMessages(String threadId) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return List<ChatMessageModel>.from(_messages[threadId] ?? const []);
  }

  Future<void> connect(String threadId) => _socketService.connect(threadId);

  Future<void> disconnect(String threadId) => _socketService.disconnect(threadId);

  Stream<ChatMessageModel> stream(String threadId) {
    return _socketService.stream(threadId).map((message) {
      _messages.putIfAbsent(threadId, () => <ChatMessageModel>[]).add(message);
      _updateThreadPreview(threadId, message);
      return message;
    });
  }

  Future<ChatMessageModel> sendText({
    required String threadId,
    required String text,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final message = ChatMessageModel(
      id: 'm_${DateTime.now().millisecondsSinceEpoch}',
      chatId: threadId,
      senderId: 'me',
      senderName: 'Me',
      text: text,
      imageUrl: null,
      sentAt: DateTime.now(),
      isMine: true,
      isRead: false,
    );
    _messages.putIfAbsent(threadId, () => <ChatMessageModel>[]).add(message);
    _updateThreadPreview(threadId, message);
    final thread = _threads.firstWhere((item) => item.id == threadId);
    _socketService.scheduleReply(
      threadId: threadId,
      senderName: thread.title,
      replyText: 'Received. We will confirm in a moment.',
    );
    return message;
  }

  Future<ChatMessageModel> sendImagePlaceholder({required String threadId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final message = ChatMessageModel(
      id: 'img_${DateTime.now().millisecondsSinceEpoch}',
      chatId: threadId,
      senderId: 'me',
      senderName: 'Me',
      text: '',
      imageUrl: 'https://example.com/image-placeholder.jpg',
      sentAt: DateTime.now(),
      isMine: true,
      isRead: false,
    );
    _messages.putIfAbsent(threadId, () => <ChatMessageModel>[]).add(message);
    _updateThreadPreview(threadId, message, preview: 'Image sent');
    return message;
  }

  void _updateThreadPreview(
    String threadId,
    ChatMessageModel message, {
    String? preview,
  }) {
    final index = _threads.indexWhere((thread) => thread.id == threadId);
    if (index == -1) return;

    final current = _threads[index];
    _threads[index] = ChatThreadModel(
      id: current.id,
      title: current.title,
      subtitle: current.subtitle,
      unreadCount: message.isMine ? current.unreadCount : current.unreadCount + 1,
      lastMessagePreview: preview ?? message.text,
      lastMessageAt: message.sentAt,
      taskId: current.taskId,
      isOnline: current.isOnline,
    );
  }
}
