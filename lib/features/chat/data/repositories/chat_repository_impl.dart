import 'package:jobi/core/constants/app_constants.dart';
import 'package:jobi/features/chat/data/datasources/chat_mock_data_source.dart';
import 'package:jobi/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:jobi/features/chat/domain/entities/chat_entities.dart';
import 'package:jobi/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  const ChatRepositoryImpl({
    required this.remoteDataSource,
    required this.mockDataSource,
  });

  final ChatRemoteDataSource remoteDataSource;
  final ChatMockDataSource mockDataSource;

  @override
  Future<List<ChatThread>> getThreads() {
    return AppConstants.useMockData
        ? mockDataSource.getThreads()
        : remoteDataSource.getThreads();
  }

  @override
  Future<List<ChatMessage>> getMessages(String threadId) {
    return AppConstants.useMockData
        ? mockDataSource.getMessages(threadId)
        : remoteDataSource.getMessages(threadId);
  }

  @override
  Future<void> connect(String threadId) {
    return AppConstants.useMockData
        ? mockDataSource.connect(threadId)
        : remoteDataSource.connect(threadId);
  }

  @override
  Future<void> disconnect(String threadId) {
    return AppConstants.useMockData
        ? mockDataSource.disconnect(threadId)
        : remoteDataSource.disconnect(threadId);
  }

  @override
  Stream<ChatMessage> incomingMessages(String threadId) {
    return AppConstants.useMockData
        ? mockDataSource.stream(threadId)
        : remoteDataSource.stream(threadId);
  }

  @override
  Future<ChatMessage> sendText({
    required String threadId,
    required String text,
  }) {
    return AppConstants.useMockData
        ? mockDataSource.sendText(threadId: threadId, text: text)
        : remoteDataSource.sendText(threadId: threadId, text: text);
  }

  @override
  Future<ChatMessage> sendImagePlaceholder({required String threadId}) {
    return AppConstants.useMockData
        ? mockDataSource.sendImagePlaceholder(threadId: threadId)
        : remoteDataSource.sendImagePlaceholder(threadId: threadId);
  }
}
