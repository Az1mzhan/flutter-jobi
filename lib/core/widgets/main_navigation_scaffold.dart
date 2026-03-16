import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex(),
        onDestinationSelected: (index) => context.go(_destinations[index].$1),
        destinations: _destinations
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
