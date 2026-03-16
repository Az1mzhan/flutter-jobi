# JOBI Flutter MVP Frontend

Production-oriented Flutter mobile frontend scaffold for JOBI, an instant geo-based hiring platform for Kazakhstan. The project is organized with clean architecture boundaries, feature modules, Bloc/Cubit state management, GoRouter navigation, Dio networking, secure session storage, and mock-ready repositories so the app can demonstrate end-to-end UX before the backend is fully connected.

## Scope

Included:
- Mobile-first Flutter frontend for iOS and Android
- Auth flow with splash, email login, phone OTP, registration, Google placeholder, session restore, and logout
- Role-aware UX foundation for worker, employer, entrepreneur, company, and brigade roles
- Profile, geo search, tasks, chat, notifications, ratings/history, and brigade modules
- REST client layer, DTOs, repository boundaries, token refresh interceptor, and WebSocket-ready chat abstraction
- Mock/demo data and sample JSON contracts

Excluded:
- Backend/server/database implementation
- Desktop/web admin frontend
- Payments, escrow, monetization, AI recommendations, banking, blockchain/token features

## Architecture

`lib/`
- `core/`: theme, routing, storage, errors, networking, shared widgets, constants
- `features/auth`: session and onboarding flows
- `features/profile`: editable user profile, stats, work history
- `features/search`: geo search for workers and tasks with filters and pagination
- `features/tasks`: task creation, list, details, status transitions
- `features/chat`: chat list, detail, message UI, mock socket abstraction
- `features/notifications`: notification center and routing hooks
- `features/brigades`: brigade listing, create flow, detail/member management
- `features/home`: post-login dashboard shell

Layer intent:
- `presentation/`: pages, cubits, UI widgets
- `domain/`: entities, repository contracts, representative use cases
- `data/`: DTO/models, data sources, repository implementations

## Tech Choices

- Flutter + Dart
- `flutter_bloc`
- `go_router`
- `dio`
- `flutter_secure_storage`
- `shared_preferences`
- `google_fonts`
- Mock-first repository switching via compile-time environment flags

## Setup

1. Install Flutter stable and verify it with `flutter doctor`.
2. From the project root, generate native runners if needed:
   `flutter create . --platforms=android,ios`
3. Install dependencies:
   `flutter pub get`
4. Run the app in mock mode:
   `flutter run --dart-define=JOBI_USE_MOCKS=true`

Optional real-backend run:
`flutter run --dart-define=JOBI_USE_MOCKS=false --dart-define=JOBI_BASE_URL=https://your-api --dart-define=JOBI_WS_URL=wss://your-ws`

## Environment Config

Configured in [app_constants.dart](/C:/Users/user/WebstormProjects/jobi/lib/core/constants/app_constants.dart):

- `JOBI_USE_MOCKS`
- `JOBI_BASE_URL`
- `JOBI_WS_URL`

Defaults:
- Mock data enabled
- Base URL: `https://api.jobi.kz/v1`
- WS URL: `wss://api.jobi.kz/ws`

## Backend Integration Notes

Placeholder REST contracts currently target:
- `/auth/login`
- `/auth/register`
- `/auth/refresh`
- `/auth/login/otp/send`
- `/auth/login/otp/verify`
- `/users/me`
- `/profiles/update`
- `/search/workers`
- `/search/tasks`
- `/tasks`
- `/tasks/{id}`
- `/chats`
- `/chats/{id}/messages`
- `/messages`
- `/notifications`
- `/brigades`

To connect the real backend:
1. Set `JOBI_USE_MOCKS=false`.
2. Replace placeholder response mapping in each `*_remote_data_source.dart`.
3. Finalize request/response DTOs to match backend JSON.
4. Replace the mock chat socket service with the real WebSocket implementation.
5. Optionally extend repositories to support remote brigade create/member management once those endpoints are ready.

## Mocked vs Real

Mocked today:
- Auth success flows and OTP verification (`123456`)
- Profile load/update
- Worker and task search results
- Task creation and lifecycle transitions
- Chat list/history and socket-style reply simulation
- Notifications list/read state
- Brigade CRUD-like demo flows

Real-ready structure already present:
- Dio API client
- Auth interceptor with refresh flow
- Secure session persistence
- Remote data source classes for each major feature
- Route guards and protected shell navigation

## Sample Contracts

Example JSON payloads are included in:
- [auth_login.json](/C:/Users/user/WebstormProjects/jobi/assets/mock/auth_login.json)
- [profile_me.json](/C:/Users/user/WebstormProjects/jobi/assets/mock/profile_me.json)
- [tasks_list.json](/C:/Users/user/WebstormProjects/jobi/assets/mock/tasks_list.json)

## UX Notes

- Bottom navigation: Home, Search, Tasks, Chat, Profile
- FAB for task creation
- Filter chips and bottom-sheet filters for search
- Status chips and timeline treatment for tasks
- Read/unread treatment for notifications
- Message bubbles, timestamps, image placeholders, and connection state in chat

## Important Note

This environment did not have the Flutter SDK available, so I could not run `flutter pub get`, generate `android/` and `ios/` runner folders automatically, or compile-test the project here. The Flutter app code, structure, dependencies, and integration points are in place, but you should run the setup steps above on a machine with Flutter installed to generate the native runners and verify compilation.
