import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jobi/core/constants/user_roles.dart';
import 'package:jobi/core/widgets/primary_button.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final roles = RoleType.values.where((role) => role != RoleType.administrator);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Text(
                'Hire fast. Get hired nearby.',
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.05,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'JOBI helps employers, workers, and brigades connect instantly across Kazakhstan with geo-based search, task management, and chat.',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: roles
                    .map(
                      (role) => Chip(
                        avatar: const Icon(Icons.check_circle_outline_rounded, size: 18),
                        label: Text(role.label),
                      ),
                    )
                    .toList(),
              ),
              const Spacer(),
              PrimaryButton(
                label: 'Create account',
                onPressed: () => context.go('/auth/sign-up'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.go('/auth/sign-in'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                ),
                child: const Text('I already have an account'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
