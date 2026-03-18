import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:jobi/core/l10n/app_localizations.dart';
import 'package:jobi/core/l10n/locale_cubit.dart';
import 'package:jobi/core/routing/app_router.dart';
import 'package:jobi/core/storage/preferences_service.dart';
import 'package:jobi/core/theme/app_theme.dart';
import 'package:jobi/features/auth/domain/repositories/auth_repository.dart';
import 'package:jobi/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:jobi/features/brigades/domain/repositories/brigades_repository.dart';
import 'package:jobi/features/brigades/presentation/cubit/brigades_cubit.dart';
import 'package:jobi/features/chat/domain/repositories/chat_repository.dart';
import 'package:jobi/features/chat/presentation/cubit/chat_detail_cubit.dart';
import 'package:jobi/features/chat/presentation/cubit/chat_list_cubit.dart';
import 'package:jobi/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:jobi/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:jobi/features/profile/domain/repositories/profile_repository.dart';
import 'package:jobi/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:jobi/features/search/domain/repositories/search_repository.dart';
import 'package:jobi/features/search/presentation/cubit/search_cubit.dart';
import 'package:jobi/features/tasks/domain/repositories/tasks_repository.dart';
import 'package:jobi/features/tasks/presentation/cubit/tasks_cubit.dart';

class AppDependencies {
  const AppDependencies({
    required this.authRepository,
    required this.profileRepository,
    required this.searchRepository,
    required this.tasksRepository,
    required this.chatRepository,
    required this.notificationsRepository,
    required this.brigadesRepository,
    required this.preferencesService,
  });

  final AuthRepository authRepository;
  final ProfileRepository profileRepository;
  final SearchRepository searchRepository;
  final TasksRepository tasksRepository;
  final ChatRepository chatRepository;
  final NotificationsRepository notificationsRepository;
  final BrigadesRepository brigadesRepository;
  final PreferencesService preferencesService;
}

class JobiApp extends StatefulWidget {
  const JobiApp({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  State<JobiApp> createState() => _JobiAppState();
}

class _JobiAppState extends State<JobiApp> {
  late final AuthCubit _authCubit;
  late final ProfileCubit _profileCubit;
  late final SearchCubit _searchCubit;
  late final TasksCubit _tasksCubit;
  late final ChatListCubit _chatListCubit;
  late final ChatDetailCubit _chatDetailCubit;
  late final NotificationsCubit _notificationsCubit;
  late final BrigadesCubit _brigadesCubit;
  late final LocaleCubit _localeCubit;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authCubit = AuthCubit(widget.dependencies.authRepository)..restoreSession();
    _profileCubit = ProfileCubit(widget.dependencies.profileRepository);
    _searchCubit = SearchCubit(widget.dependencies.searchRepository);
    _tasksCubit = TasksCubit(widget.dependencies.tasksRepository);
    _chatListCubit = ChatListCubit(widget.dependencies.chatRepository);
    _chatDetailCubit = ChatDetailCubit(widget.dependencies.chatRepository);
    _notificationsCubit =
        NotificationsCubit(widget.dependencies.notificationsRepository);
    _brigadesCubit = BrigadesCubit(widget.dependencies.brigadesRepository);
    _localeCubit = LocaleCubit(widget.dependencies.preferencesService)
      ..loadSavedLocale();
    _router = AppRouter(authCubit: _authCubit).router;
  }

  @override
  void dispose() {
    _authCubit.close();
    _profileCubit.close();
    _searchCubit.close();
    _tasksCubit.close();
    _chatListCubit.close();
    _chatDetailCubit.close();
    _notificationsCubit.close();
    _brigadesCubit.close();
    _localeCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: widget.dependencies.authRepository),
        RepositoryProvider.value(value: widget.dependencies.profileRepository),
        RepositoryProvider.value(value: widget.dependencies.searchRepository),
        RepositoryProvider.value(value: widget.dependencies.tasksRepository),
        RepositoryProvider.value(value: widget.dependencies.chatRepository),
        RepositoryProvider.value(value: widget.dependencies.notificationsRepository),
        RepositoryProvider.value(value: widget.dependencies.brigadesRepository),
        RepositoryProvider.value(value: widget.dependencies.preferencesService),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _authCubit),
          BlocProvider.value(value: _profileCubit),
          BlocProvider.value(value: _searchCubit),
          BlocProvider.value(value: _tasksCubit),
          BlocProvider.value(value: _chatListCubit),
          BlocProvider.value(value: _chatDetailCubit),
          BlocProvider.value(value: _notificationsCubit),
          BlocProvider.value(value: _brigadesCubit),
          BlocProvider.value(value: _localeCubit),
        ],
        child: BlocBuilder<LocaleCubit, Locale>(
          builder: (context, locale) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light(),
              locale: locale,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: const [
                AppLocalizationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              routerConfig: _router,
            );
          },
        ),
      ),
    );
  }
}
