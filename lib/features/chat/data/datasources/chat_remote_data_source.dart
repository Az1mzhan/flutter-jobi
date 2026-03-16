import 'package:jobi/core/constants/api_endpoints.dart';
import 'package:jobi/core/network/api_client.dart';
import 'package:jobi/features/chat/data/datasources/chat_socket_service.dart';
import 'package:jobi/features/chat/data/models/chat_models.dart';

class ChatRemoteDataSource {
  ChatRemoteDataSource(this._apiClient, this._socketService);

  final ApiClient _apiClient;
  final ChatSocketService _socketService;

  Future<List<ChatThreadModel>> getThreads() async {
    final response = await _apiClient.get(ApiEndpoints.chats);
    return (response.data as List<dynamic>)
        .map((item) => ChatThreadModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<ChatMessageModel>> getMessages(String threadId) async {
    final response = await _apiClient.get('${ApiEndpoints.chats}/$threadId/messages');
    return (response.data as List<dynamic>)
        .map((item) => ChatMessageModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<ChatMessageModel> sendText({
    required String threadId,
    required String text,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.messages,
      data: {
        'chatId': threadId,
        'text': text,
      },
    );
    return ChatMessageModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<ChatMessageModel> sendImagePlaceholder({required String threadId}) async {
    final response = await _apiClient.post(
      ApiEndpoints.messages,
      data: {
        'chatId': threadId,
        'text': '',
        'imageUrl': 'placeholder://pending-upload',
      },
    );
    return ChatMessageModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> connect(String threadId) => _socketService.connect(threadId);

  Future<void> disconnect(String threadId) => _socketService.disconnect(threadId);

  Stream<ChatMessageModel> stream(String threadId) => _socketService.stream(threadId);
}
