import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jobi/core/constants/user_roles.dart';
import 'package:jobi/core/l10n/app_localizations.dart';
import 'package:jobi/core/l10n/enum_localizations.dart';
import 'package:jobi/core/widgets/primary_button.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
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
                l10n.text('welcomeTitle'),
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.05,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.text('welcomeSubtitle'),
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
                        label: Text(role.localizedLabel(context)),
                      ),
                    )
                    .toList(),
              ),
              const Spacer(),
              PrimaryButton(
                label: l10n.text('createAccount'),
                onPressed: () => context.go('/auth/sign-up'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.go('/auth/sign-in'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                ),
                child: Text(l10n.text('alreadyHaveAccount')),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
