import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jobi/core/l10n/app_localizations.dart';

class MainNavigationScaffold extends StatelessWidget {
  const MainNavigationScaffold({
    super.key,
    required this.location,
    required this.child,
  });

  final String location;
  final Widget child;

  static const _destinations = [
    ('/home', 'Home', Icons.home_rounded),
    ('/search', 'Search', Icons.travel_explore_rounded),
    ('/tasks', 'Tasks', Icons.assignment_rounded),
    ('/chat', 'Chat', Icons.chat_bubble_rounded),
    ('/profile', 'Profile', Icons.person_rounded),
  ];

  int _selectedIndex() {
    for (var index = 0; index < _destinations.length; index++) {
      if (location.startsWith(_destinations[index].$1)) {
        return index;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final destinations = [
      ('/home', l10n.text('navHome'), Icons.home_rounded),
      ('/search', l10n.text('navSearch'), Icons.travel_explore_rounded),
      ('/tasks', l10n.text('navTasks'), Icons.assignment_rounded),
      ('/chat', l10n.text('navChat'), Icons.chat_bubble_rounded),
      ('/profile', l10n.text('navProfile'), Icons.person_rounded),
    ];

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex(),
        onDestinationSelected: (index) => context.go(destinations[index].$1),
        destinations: destinations
            .map(
              (item) => NavigationDestination(
                icon: Icon(item.$3),
                label: item.$2,
              ),
            )
            .toList(),
      ),
    );
  }
}
