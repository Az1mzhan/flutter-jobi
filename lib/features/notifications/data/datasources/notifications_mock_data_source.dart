import 'package:jobi/core/constants/app_constants.dart';
import 'package:jobi/features/notifications/data/models/notification_model.dart';

class NotificationsMockDataSource {
  final List<NotificationModel> _notifications = [
    NotificationModel(
      id: 'n1',
      title: 'Новый отклик на вашу задачу',
      body: 'Айдана К. откликнулась на задачу "Покраска офиса"',
      type: 'task',
      createdAt: DateTime.now().subtract(const Duration(minutes: 25)),
      isRead: false,
      route: '/tasks/task_1',
    ),
    NotificationModel(
      id: 'n2',
      title: 'Новое сообщение',
      body: 'Хан Строй отправил новое сообщение',
      type: 'chat',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
      route: '/chat/chat_1',
    ),
    NotificationModel(
      id: 'n3',
      title: 'Задача завершена',
      body: 'Ремонт плитки в ванной отмечен как завершенный',
      type: 'task',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      route: '/tasks/task_4',
    ),
  ];

  Future<List<NotificationModel>> getNotifications() async {
    await Future<void>.delayed(AppConstants.mockDelay);
    return List<NotificationModel>.from(_notifications);
  }

  Future<void> markRead(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final index = _notifications.indexWhere((item) => item.id == id);
    if (index != -1) {
      _notifications[index] = NotificationModel(
        id: _notifications[index].id,
        title: _notifications[index].title,
        body: _notifications[index].body,
        type: _notifications[index].type,
        createdAt: _notifications[index].createdAt,
        isRead: true,
        route: _notifications[index].route,
      );
    }
  }
}
