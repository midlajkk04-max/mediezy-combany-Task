import 'package:flutter/material.dart';
import '../dashboard/dashboard_screen.dart';
import '../leave/apply_leave_screen.dart';
import '../leave/leave_list_screen.dart';
import '../route/route_list_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    LeaveListScreen(),
    ApplyLeaveScreen(),
    RouteListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF005B4E),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Leaves'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Apply'),
          BottomNavigationBarItem(icon: Icon(Icons.route), label: 'Route'),
        ],
      ),
    );
  }
}
