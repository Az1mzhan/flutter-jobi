import 'package:go_router/go_router.dart';
import 'package:jobi/core/utils/go_router_refresh_stream.dart';
import 'package:jobi/core/widgets/main_navigation_scaffold.dart';
import 'package:jobi/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:jobi/features/auth/presentation/pages/otp_page.dart';
import 'package:jobi/features/auth/presentation/pages/sign_in_page.dart';
import 'package:jobi/features/auth/presentation/pages/sign_up_page.dart';
import 'package:jobi/features/auth/presentation/pages/splash_page.dart';
import 'package:jobi/features/auth/presentation/pages/welcome_page.dart';
import 'package:jobi/features/brigades/presentation/pages/brigade_detail_page.dart';
import 'package:jobi/features/brigades/presentation/pages/brigades_page.dart';
import 'package:jobi/features/brigades/presentation/pages/create_brigade_page.dart';
import 'package:jobi/features/chat/presentation/pages/chat_detail_page.dart';
import 'package:jobi/features/chat/presentation/pages/chat_list_page.dart';
import 'package:jobi/features/home/presentation/pages/home_page.dart';
import 'package:jobi/features/notifications/presentation/pages/notifications_page.dart';
import 'package:jobi/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:jobi/features/profile/presentation/pages/profile_page.dart';
import 'package:jobi/features/profile/presentation/pages/work_history_page.dart';
import 'package:jobi/features/search/presentation/pages/search_page.dart';
import 'package:jobi/features/tasks/presentation/pages/create_task_page.dart';
import 'package:jobi/features/tasks/presentation/pages/task_details_page.dart';
import 'package:jobi/features/tasks/presentation/pages/tasks_page.dart';

class AppRouter {
  AppRouter({required AuthCubit authCubit})
      : router = GoRouter(
          initialLocation: '/splash',
          refreshListenable: GoRouterRefreshStream(authCubit.stream),
          redirect: (context, state) {
            final status = authCubit.state.status;
            final path = state.uri.path;
            final isSplash = path == '/splash';
            final isAuth = path.startsWith('/auth');

            if (status == AuthStatus.unknown) {
              return isSplash ? null : '/splash';
            }

            if (!authCubit.state.isAuthenticated) {
              return isAuth ? null : '/auth/welcome';
            }

            if (isSplash || isAuth) return '/home';
            return null;
          },
          routes: [
            GoRoute(
              path: '/splash',
              builder: (context, state) => const SplashPage(),
            ),
            GoRoute(
              path: '/auth/welcome',
              builder: (context, state) => const WelcomePage(),
            ),
            GoRoute(
              path: '/auth/sign-in',
              builder: (context, state) => const SignInPage(),
            ),
            GoRoute(
              path: '/auth/sign-up',
              builder: (context, state) => const SignUpPage(),
            ),
            GoRoute(
              path: '/auth/otp',
              builder: (context, state) => OtpPage(
                phone: state.uri.queryParameters['phone'] ?? '',
              ),
            ),
            ShellRoute(
              builder: (context, state, child) {
                return MainNavigationScaffold(
                  location: state.uri.path,
                  child: child,
                );
              },
              routes: [
                GoRoute(
                  path: '/home',
                  builder: (context, state) => const HomePage(),
                ),
                GoRoute(
                  path: '/search',
                  builder: (context, state) => const SearchPage(),
                ),
                GoRoute(
                  path: '/tasks',
                  builder: (context, state) => const TasksPage(),
                ),
                GoRoute(
                  path: '/chat',
                  builder: (context, state) => const ChatListPage(),
                ),
                GoRoute(
                  path: '/profile',
                  builder: (context, state) => const ProfilePage(),
                ),
              ],
            ),
            GoRoute(
              path: '/tasks/create',
              builder: (context, state) => const CreateTaskPage(),
            ),
            GoRoute(
              path: '/tasks/:id',
              builder: (context, state) => TaskDetailsPage(
                taskId: state.pathParameters['id']!,
              ),
            ),
            GoRoute(
              path: '/chat/:id',
              builder: (context, state) => ChatDetailPage(
                threadId: state.pathParameters['id']!,
              ),
            ),
            GoRoute(
              path: '/profile/edit',
              builder: (context, state) => const EditProfilePage(),
            ),
            GoRoute(
              path: '/profile/history',
              builder: (context, state) => const WorkHistoryPage(),
            ),
            GoRoute(
              path: '/brigades',
              builder: (context, state) => const BrigadesPage(),
            ),
            GoRoute(
              path: '/brigades/create',
              builder: (context, state) => const CreateBrigadePage(),
            ),
            GoRoute(
              path: '/brigades/:id',
              builder: (context, state) => BrigadeDetailPage(
                brigadeId: state.pathParameters['id']!,
              ),
            ),
            GoRoute(
              path: '/notifications',
              builder: (context, state) => const NotificationsPage(),
            ),
          ],
        );

  final GoRouter router;
}
