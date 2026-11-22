import 'package:flutter/material.dart';

// The app frame is the one place in core/ that knows the feature screens:
// it composes them into tabs, so it sits above the features.
import '../features/favorites/presentation/favorites_screen.dart';
import '../features/home/presentation/home_screen.dart';
import 'theme/app_colors.dart';

/// The app frame: bottom navigation + the screen of the selected tab.
/// Stateful only for the selected tab index (local UI state, no Riverpod).
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  // Grocery List and Chat (index 2, 3) are not built yet.
  static const _tabs = [HomeScreen(), FavoritesScreen()];

  void _onTabTapped(int index) {
    if (index >= _tabs.length) return; // placeholder tab, ignore
    setState(() => _index = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack keeps both tabs alive, so scroll positions are kept.
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _index,
        onTap: _onTabTapped,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textPrimary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.wb_sunny_outlined),
            label: 'Today',
          ),
          // Replaces the design's "Meal Plan" tab for sprint 2.
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket_outlined),
            label: 'Grocery List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chat',
          ),
        ],
      ),
    );
  }
}
