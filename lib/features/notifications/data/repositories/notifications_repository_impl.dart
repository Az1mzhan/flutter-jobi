import 'package:jobi/core/constants/app_constants.dart';
import 'package:jobi/features/notifications/data/datasources/notifications_mock_data_source.dart';
import 'package:jobi/features/notifications/data/datasources/notifications_remote_data_source.dart';
import 'package:jobi/features/notifications/domain/entities/app_notification.dart';
import 'package:jobi/features/notifications/domain/repositories/notifications_repository.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  const NotificationsRepositoryImpl({
    required this.remoteDataSource,
    required this.mockDataSource,
  });

  final NotificationsRemoteDataSource remoteDataSource;
  final NotificationsMockDataSource mockDataSource;

  @override
  Future<List<AppNotification>> getNotifications() {
    return AppConstants.useMockData
        ? mockDataSource.getNotifications()
        : remoteDataSource.getNotifications();
  }

  @override
  Future<void> markRead(String id) {
    return AppConstants.useMockData
        ? mockDataSource.markRead(id)
        : remoteDataSource.markRead(id);
  }
}
