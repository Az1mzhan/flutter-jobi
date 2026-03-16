import 'package:jobi/core/constants/api_endpoints.dart';
import 'package:jobi/core/network/api_client.dart';
import 'package:jobi/features/notifications/data/models/notification_model.dart';

class NotificationsRemoteDataSource {
  const NotificationsRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<List<NotificationModel>> getNotifications() async {
    final response = await _apiClient.get(ApiEndpoints.notifications);
    return (response.data as List<dynamic>)
        .map((item) => NotificationModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> markRead(String id) async {
    await _apiClient.put('${ApiEndpoints.notifications}/$id');
  }
}
