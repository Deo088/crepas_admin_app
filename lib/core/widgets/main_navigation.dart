import 'package:flutter/material.dart';

import 'package:crepas_admin_app/features/dashboard/presentation/dashboard_screen.dart';
import 'package:crepas_admin_app/features/inventory/presentation/inventory_screen.dart';
import 'package:crepas_admin_app/features/kitchen/presentation/kitchen_screen.dart';
import 'package:crepas_admin_app/features/pos/presentation/pos_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int currentIndex = 0;

  final List<Widget> screens = [
    const DashboardScreen(),
    const PosScreen(),
    const KitchenScreen(),
    const InventoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(icon: Icon(Icons.point_of_sale), label: 'POS'),
          NavigationDestination(icon: Icon(Icons.restaurant), label: 'Kitchen'),
          NavigationDestination(
            icon: Icon(Icons.inventory),
            label: 'Inventory',
          ),
        ],
      ),
    );
  }
}
