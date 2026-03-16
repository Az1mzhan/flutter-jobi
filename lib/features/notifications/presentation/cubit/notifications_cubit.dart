import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobi/features/notifications/domain/entities/app_notification.dart';
import 'package:jobi/features/notifications/domain/repositories/notifications_repository.dart';

enum NotificationsStatus { initial, loading, loaded, error }

class NotificationsState extends Equatable {
  const NotificationsState({
    this.status = NotificationsStatus.initial,
    this.notifications = const [],
    this.message,
  });

  final NotificationsStatus status;
  final List<AppNotification> notifications;
  final String? message;

  NotificationsState copyWith({
    NotificationsStatus? status,
    List<AppNotification>? notifications,
    String? message,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, notifications, message];
}

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this._repository) : super(const NotificationsState());

  final NotificationsRepository _repository;

  Future<void> loadNotifications() async {
    emit(state.copyWith(status: NotificationsStatus.loading));
    try {
      final notifications = await _repository.getNotifications();
      emit(
        NotificationsState(
          status: NotificationsStatus.loaded,
          notifications: notifications,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: NotificationsStatus.error,
          message: 'Unable to load notifications.',
        ),
      );
    }
  }

  Future<void> markRead(String id) async {
    await _repository.markRead(id);
    final updated = state.notifications
        .map((item) => item.id == id ? item.copyWith(isRead: true) : item)
        .toList(growable: false);
    emit(state.copyWith(status: NotificationsStatus.loaded, notifications: updated));
  }
}
