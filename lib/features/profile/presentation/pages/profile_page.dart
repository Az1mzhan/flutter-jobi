import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jobi/core/constants/user_roles.dart';
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
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state.status == ProfileStatus.loading && state.profile == null) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (state.status == ProfileStatus.error && state.profile == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Profile')),
            body: ErrorStateView(
              message: state.message ?? 'Unable to load profile',
              onRetry: () => context.read<ProfileCubit>().loadProfile(),
            ),
          );
        }

        final profile = state.profile;
        if (profile == null) {
          return const Scaffold(
            body: EmptyStateView(
              title: 'No profile yet',
              message: 'Profile details will appear here after sign-in.',
            ),
          );
        }

        final dateFormat = DateFormat('d MMM yyyy');

        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
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
                                'Active role',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 12),
                              DropdownButtonFormField<RoleType>(
                                value: authState.activeRole,
                                items: authState.availableRoles
                                    .map(
                                      (role) => DropdownMenuItem<RoleType>(
                                        value: role,
                                        child: Text(role.label),
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
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('About', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 12),
                          Text(profile.about),
                          const SizedBox(height: 20),
                          SwitchListTile.adaptive(
                            value: profile.availableNow,
                            title: const Text('Available now'),
                            subtitle: const Text('Show employers that you can start quickly'),
                            contentPadding: EdgeInsets.zero,
                            onChanged: (value) =>
                                context.read<ProfileCubit>().toggleAvailability(value),
                          ),
                          SwitchListTile.adaptive(
                            value: profile.readyToTravel,
                            title: const Text('Ready to travel'),
                            subtitle: const Text('Accept jobs outside your current city'),
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
                        label: 'Rating',
                        value: profile.rating.toStringAsFixed(1),
                        icon: Icons.star_rounded,
                      ),
                      ProfileStatTile(
                        label: 'Total tasks',
                        value: profile.totalTasks.toString(),
                        icon: Icons.work_outline_rounded,
                      ),
                      ProfileStatTile(
                        label: 'Successful',
                        value: profile.successfulTasks.toString(),
                        icon: Icons.verified_rounded,
                      ),
                      ProfileStatTile(
                        label: 'Cancellations',
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
                            'Professions & experience',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: profile.experience
                                .map(
                                  (item) => Chip(
                                    label: Text('${item.profession} · ${item.months} mo'),
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
                                'First job: ${dateFormat.format(profile.firstJobDate)}',
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
                            'Work history preview',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 12),
                          ...profile.workHistory.take(3).map(
                                (item) => ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(item.title),
                                  subtitle: Text('${item.counterparty} · ${item.status}'),
                                  trailing: Text('${item.amount.toInt()} KZT'),
                                ),
                              ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 12,
                            children: [
                              OutlinedButton(
                                onPressed: () => context.push('/profile/history'),
                                child: const Text('Open full history'),
                              ),
                              OutlinedButton(
                                onPressed: () => context.push('/brigades'),
                                child: const Text('Brigades'),
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
                    label: const Text('Log out'),
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
            CircleAvatar(
              radius: 34,
              child: Text(
                profile.fullName.isNotEmpty ? profile.fullName[0] : '?',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
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
