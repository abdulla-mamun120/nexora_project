import 'package:flutter/material.dart';
import '../app_colors.dart';
import 'home_tab.dart';
import 'notices_tab.dart';
import 'services_tab.dart';
import 'area_guide_tab.dart';
import 'profile_tab.dart';
import '../strings.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Chip selected from a Home shortcut ('All' if none)
  String _category = 'All';

  // Called by HomeTab to open another tab
  void _goToTab(int index, String category) {
    setState(() {
      _currentIndex = index;
      _category = category;
    });
  }

  // Not const anymore, because HomeTab needs the function above
  List<Widget> get _pages => [
        HomeTab(onGoToTab: _goToTab),
        const NoticesTab(),
        ServicesTab(initialCategory: _category),
        AreaGuideTab(initialCategory: _category),
        const ProfileTab(),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFE0F2F1),
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
            _category = 'All'; // tapping the bottom bar clears the shortcut
          });
        },
                destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home, color: AppColors.primary),
            label: t('nav_home'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.description_outlined),
            selectedIcon:
                const Icon(Icons.description, color: AppColors.primary),
            label: t('nav_notices'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.build_outlined),
            selectedIcon: const Icon(Icons.build, color: AppColors.primary),
            label: t('nav_services'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.map_outlined),
            selectedIcon: const Icon(Icons.map, color: AppColors.primary),
            label: t('nav_area_guide'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person, color: AppColors.primary),
            label: t('nav_profile'),
          ),
        ],
      ),
    );
  }
}

// Temporary page for tabs that are not built yet
class PlaceholderTab extends StatelessWidget {
  final String title;

  const PlaceholderTab({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$title - Coming soon',
        style: const TextStyle(fontSize: 20, color: AppColors.textLight),
      ),
    );
  }
}