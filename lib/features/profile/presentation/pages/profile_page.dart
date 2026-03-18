import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jobi/core/l10n/app_localizations.dart';
import 'package:jobi/core/l10n/enum_localizations.dart';
import 'package:jobi/core/l10n/locale_cubit.dart';
import 'package:jobi/core/widgets/state_views.dart';
import 'package:jobi/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:jobi/features/profile/domain/entities/user_profile.dart';
import 'package:jobi/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:jobi/features/profile/presentation/widgets/profile_stat_tile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<ProfileCubit>().state.profile == null) {
        context.read<ProfileCubit>().loadProfile();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state.status == ProfileStatus.loading && state.profile == null) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (state.status == ProfileStatus.error && state.profile == null) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.text('profileTitle'))),
            body: ErrorStateView(
              message: state.message ?? l10n.text('networkError'),
              onRetry: () => context.read<ProfileCubit>().loadProfile(),
            ),
          );
        }

        final profile = state.profile;
        if (profile == null) {
          return Scaffold(
            body: EmptyStateView(
              title: l10n.text('noProfileYet'),
              message: l10n.text('profileAppearsAfterSignIn'),
            ),
          );
        }

        final dateFormat = DateFormat('d MMM yyyy', l10n.localeName);

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.text('profileTitle')),
            actions: [
              IconButton(
                onPressed: () => context.push('/notifications'),
                icon: const Icon(Icons.notifications_none_rounded),
              ),
              IconButton(
                onPressed: () => context.push('/profile/edit'),
                icon: const Icon(Icons.edit_outlined),
              ),
            ],
          ),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () => context.read<ProfileCubit>().loadProfile(),
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _ProfileHeader(profile: profile),
                  const SizedBox(height: 16),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, authState) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.text('activeRole'),
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 12),
                              DropdownButtonFormField(
                                initialValue: authState.activeRole,
                                items: authState.availableRoles
                                    .map(
                                      (role) => DropdownMenuItem(
                                        value: role,
                                        child: Text(role.localizedLabel(context)),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    context.read<AuthCubit>().switchRole(value);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<LocaleCubit, Locale>(
                    builder: (context, locale) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.text('appLanguage'),
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                l10n.text('languageHint'),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 12),
                              DropdownButtonFormField<String>(
                                initialValue: locale.languageCode,
                                decoration: InputDecoration(
                                  labelText: l10n.text('language'),
                                ),
                                items: [
                                  DropdownMenuItem(
                                    value: 'ru',
                                    child: Text(l10n.text('languageRussian')),
                                  ),
                                  DropdownMenuItem(
                                    value: 'en',
                                    child: Text(l10n.text('languageEnglish')),
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    context.read<LocaleCubit>().changeLocale(value);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.text('about'),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 12),
                          Text(profile.about),
                          const SizedBox(height: 20),
                          SwitchListTile.adaptive(
                            value: profile.availableNow,
                            title: Text(l10n.text('availableNow')),
                            subtitle: Text(l10n.text('availableNowHint')),
                            contentPadding: EdgeInsets.zero,
                            onChanged: (value) =>
                                context.read<ProfileCubit>().toggleAvailability(value),
                          ),
                          SwitchListTile.adaptive(
                            value: profile.readyToTravel,
                            title: Text(l10n.text('readyToTravel')),
                            subtitle: Text(l10n.text('readyToTravelHint')),
                            contentPadding: EdgeInsets.zero,
                            onChanged: (value) =>
                                context.read<ProfileCubit>().toggleTravelReady(value),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    childAspectRatio: 1.18,
                    children: [
                      ProfileStatTile(
                        label: l10n.text('rating'),
                        value: profile.rating.toStringAsFixed(1),
                        icon: Icons.star_rounded,
                      ),
                      ProfileStatTile(
                        label: l10n.text('totalTasks'),
                        value: profile.totalTasks.toString(),
                        icon: Icons.work_outline_rounded,
                      ),
                      ProfileStatTile(
                        label: l10n.text('successful'),
                        value: profile.successfulTasks.toString(),
                        icon: Icons.verified_rounded,
                      ),
                      ProfileStatTile(
                        label: l10n.text('cancellations'),
                        value: profile.cancellations.toString(),
                        icon: Icons.cancel_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.text('professionsExperience'),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: profile.experience
                                .map(
                                  (item) => Chip(
                                    label: Text(
                                      '${item.profession} • ${item.months} ${l10n.text('monthsShort')}',
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              const Icon(Icons.schedule_rounded),
                              const SizedBox(width: 8),
                              Text(
                                l10n.format(
                                  'firstJob',
                                  {'date': dateFormat.format(profile.firstJobDate)},
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.text('workHistoryPreview'),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 12),
                          ...profile.workHistory.take(3).map(
                                (item) => ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(item.title),
                                  subtitle: Text('${item.counterparty} • ${item.status}'),
                                  trailing: Text('${item.amount.toInt()} KZT'),
                                ),
                              ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 12,
                            children: [
                              OutlinedButton(
                                onPressed: () => context.push('/profile/history'),
                                child: Text(l10n.text('openFullHistory')),
                              ),
                              OutlinedButton(
                                onPressed: () => context.push('/brigades'),
                                child: Text(l10n.text('brigades')),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () async {
                      await context.read<AuthCubit>().logout();
                      if (context.mounted) context.go('/auth/welcome');
                    },
                    icon: const Icon(Icons.logout_rounded),
                    label: Text(l10n.text('logout')),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            _Avatar(profile: profile),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.fullName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text('${profile.city}, ${profile.region}'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: profile.professions
                        .map((profession) => Chip(label: Text(profession)))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final avatarUrl = profile.avatarUrl.trim();
    final imageProvider = _resolveImageProvider(avatarUrl);

    return CircleAvatar(
      radius: 34,
      backgroundImage: imageProvider,
      child: imageProvider == null
          ? Text(
              profile.fullName.isNotEmpty ? profile.fullName[0] : '?',
              style: Theme.of(context).textTheme.headlineSmall,
            )
          : null,
    );
  }

  ImageProvider<Object>? _resolveImageProvider(String avatarUrl) {
    if (avatarUrl.isEmpty) return null;
    if (avatarUrl.startsWith('assets/')) {
      return AssetImage(avatarUrl);
    }
    if (avatarUrl.startsWith('http://') || avatarUrl.startsWith('https://')) {
      return NetworkImage(avatarUrl);
    }
    return null;
  }
}
