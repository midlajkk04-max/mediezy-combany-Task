import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/attendance_view_model.dart';
import '../../viewmodels/dashboard_view_model.dart';
import '../../viewmodels/route_view_model.dart';
import '../../widgets/activity_card.dart';
import '../../widgets/dashboard_action_card.dart';
import '../../widgets/profile_avatar.dart';
import 'attendance_action_banner.dart';
import '../leave/apply_leave_screen.dart';
import '../leave/leave_list_screen.dart';
import '../route/route_list_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardViewModel>().loadUser();
      context.read<AttendanceViewModel>().loadStatus();
      context.read<RouteViewModel>().loadRoutes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ListView(
            children: [
              const SizedBox(height: 26),
              const ProfileAvatar(radius: 34, iconSize: 48),
              const SizedBox(height: 12),
              Consumer<DashboardViewModel>(
                builder: (_, vm, __) => Text(
                  'Hi ${vm.name}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
              ),
              Consumer<DashboardViewModel>(
                builder: (_, vm, __) => Text(
                  '${vm.role}${vm.location.isNotEmpty ? '\n${vm.location}' : ''}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 11),
                ),
              ),
              const SizedBox(height: 24),
              Consumer<AttendanceViewModel>(
                builder: (_, vm, __) => AttendanceActionBanner(
                  status: vm.status,
                  isLoading: vm.isLoading,
                  onTap: () async {
                    final ok = await vm.markAttendance();
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          ok ? 'Attendance updated' : (vm.error ?? 'Failed'),
                        ),
                      ),
                    );
                    if (ok) {
                      context.read<RouteViewModel>().loadRoutes();
                    }
                  },
                ),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: DashboardActionCard(
                      title: 'Route',
                      icon: Icons.route,
                      dark: true,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RouteListScreen(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: DashboardActionCard(
                      title: 'Apply Leave',
                      icon: Icons.calendar_month,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ApplyLeaveScreen(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Recent Activity',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LeaveListScreen(),
                      ),
                    ),
                    child: const Text(
                      'View All  ›',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Consumer<RouteViewModel>(
                builder: (_, vm, __) {
                  if (vm.isLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (vm.routes.isEmpty) {
                    return const ActivityCard(
                      date: 'No recent activity',
                      subtitle: 'Your attendance records will appear here',
                    );
                  }
                  return Column(
                    children: vm.routes.take(3).map(
                      (route) {
                        return ActivityCard(
                          date: route.date.isNotEmpty ? route.date : 'Route',
                          markIn: route.markIn,
                          markOut: route.markOut,
                        );
                      },
                    ).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
