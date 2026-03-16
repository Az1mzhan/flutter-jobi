import 'package:jobi/features/notifications/domain/entities/app_notification.dart';

abstract class NotificationsRepository {
  Future<List<AppNotification>> getNotifications();

  Future<void> markRead(String id);
}
