import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jobi/app.dart';
import 'package:jobi/core/constants/app_constants.dart';
import 'package:jobi/core/network/api_client.dart';
import 'package:jobi/core/storage/preferences_service.dart';
import 'package:jobi/core/storage/secure_storage_service.dart';
import 'package:jobi/core/storage/session_manager.dart';
import 'package:jobi/features/auth/data/datasources/auth_mock_data_source.dart';
import 'package:jobi/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:jobi/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:jobi/features/brigades/data/datasources/brigades_mock_data_source.dart';
import 'package:jobi/features/brigades/data/datasources/brigades_remote_data_source.dart';
import 'package:jobi/features/brigades/data/repositories/brigades_repository_impl.dart';
import 'package:jobi/features/chat/data/datasources/chat_socket_service.dart';
import 'package:jobi/features/chat/data/datasources/chat_mock_data_source.dart';
import 'package:jobi/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:jobi/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:jobi/features/notifications/data/datasources/notifications_mock_data_source.dart';
import 'package:jobi/features/notifications/data/datasources/notifications_remote_data_source.dart';
import 'package:jobi/features/notifications/data/repositories/notifications_repository_impl.dart';
import 'package:jobi/features/profile/data/datasources/profile_mock_data_source.dart';
import 'package:jobi/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:jobi/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:jobi/features/search/data/datasources/search_mock_data_source.dart';
import 'package:jobi/features/search/data/datasources/search_remote_data_source.dart';
import 'package:jobi/features/search/data/repositories/search_repository_impl.dart';
import 'package:jobi/features/tasks/data/datasources/tasks_mock_data_source.dart';
import 'package:jobi/features/tasks/data/datasources/tasks_remote_data_source.dart';
import 'package:jobi/features/tasks/data/repositories/tasks_repository_impl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru');
  await initializeDateFormatting('en');

  const secureStorage = SecureStorageService(FlutterSecureStorage());
  final preferences = await PreferencesService.create();
  final sessionManager = SessionManager(secureStorage);
  final apiClient = ApiClient(
    baseUrl: AppConstants.baseUrl,
    sessionManager: sessionManager,
  );

  final tasksMockDataSource = TasksMockDataSource();
  final chatMockDataSource = ChatMockDataSource();
  final chatSocketService = MockChatSocketService();

  runApp(
    JobiApp(
      dependencies: AppDependencies(
        authRepository: AuthRepositoryImpl(
          sessionManager: sessionManager,
          remoteDataSource: AuthRemoteDataSource(apiClient),
          mockDataSource: AuthMockDataSource(),
        ),
        profileRepository: ProfileRepositoryImpl(
          remoteDataSource: ProfileRemoteDataSource(apiClient),
          mockDataSource: ProfileMockDataSource(preferences),
        ),
        searchRepository: SearchRepositoryImpl(
          remoteDataSource: SearchRemoteDataSource(apiClient),
          mockDataSource: SearchMockDataSource(
            tasksMockDataSource: tasksMockDataSource,
          ),
        ),
        tasksRepository: TasksRepositoryImpl(
          remoteDataSource: TasksRemoteDataSource(apiClient),
          mockDataSource: tasksMockDataSource,
        ),
        chatRepository: ChatRepositoryImpl(
          remoteDataSource: ChatRemoteDataSource(apiClient, chatSocketService),
          mockDataSource: chatMockDataSource,
        ),
        notificationsRepository: NotificationsRepositoryImpl(
          remoteDataSource: NotificationsRemoteDataSource(apiClient),
          mockDataSource: NotificationsMockDataSource(),
        ),
        brigadesRepository: BrigadesRepositoryImpl(
          remoteDataSource: BrigadesRemoteDataSource(apiClient),
          mockDataSource: BrigadesMockDataSource(),
        ),
        preferencesService: preferences,
      ),
    ),
  );
}
