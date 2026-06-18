import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'projects_screen.dart';
import 'about_screen.dart';
import 'contact_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<_TabItem> _tabs = [
    _TabItem(icon: Icons.home_outlined, selectedIcon: Icons.home, label: 'Home'),
    _TabItem(icon: Icons.work_outline, selectedIcon: Icons.work, label: 'Projects'),
    _TabItem(icon: Icons.person_outline, selectedIcon: Icons.person, label: 'About'),
    _TabItem(icon: Icons.mail_outline, selectedIcon: Icons.mail, label: 'Contact'),
  ];

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        children: const [
          HomeScreen(),
          ProjectsScreen(),
          AboutScreen(),
          ContactScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onTabTapped,
        destinations: _tabs
            .map((tab) => NavigationDestination(
                  icon: Icon(tab.icon),
                  selectedIcon: Icon(tab.selectedIcon),
                  label: tab.label,
                ))
            .toList(),
      ),
    );
  }
}

class _TabItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const _TabItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}
