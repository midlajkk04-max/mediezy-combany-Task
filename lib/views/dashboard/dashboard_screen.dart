import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../viewmodels/attendance_view_model.dart';
import '../../viewmodels/auth_view_model.dart';
import '../../viewmodels/dashboard_view_model.dart';
import '../../viewmodels/route_view_model.dart';
import '../../widgets/activity_card.dart';
import '../../widgets/dashboard_action_card.dart';
import '../../widgets/profile_avatar.dart';
import 'attendance_action_banner.dart';
import '../auth/login_screen.dart';
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
    final s = Responsive.scale(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Responsive.w(24, context)),
          child: ListView(
            children: [
              SizedBox(height: 26 * s),
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Center(
                    child: Column(
                      children: [
                        const ProfileAvatar(radius: 34, iconSize: 48),
                        SizedBox(height: 12 * s),
                        Consumer<DashboardViewModel>(
                          builder: (_, vm, __) => Text('Hi ${vm.name}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w800)),
                        ),
                        Consumer<DashboardViewModel>(
                          builder: (_, vm, __) => Text(vm.role,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 11)),
                        ),
                        Consumer<DashboardViewModel>(
                          builder: (_, vm, __) => vm.location.isNotEmpty
                              ? Padding(
                                  padding: EdgeInsets.only(top: 2 * s),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.location_on_outlined,
                                          size: 12, color: AppColors.grey),
                                      SizedBox(width: 2 * s),
                                      Text(vm.location,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 10,
                                              color: AppColors.textGrey)),
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                  Consumer<AuthViewModel>(
                    builder: (_, vm, __) => IconButton(
                      icon: const Icon(Icons.logout, size: 20),
                      color: AppColors.grey,
                      onPressed: () async {
                        await vm.logout();
                        if (!context.mounted) return;
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginScreen()),
                            (_) => false);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24 * s),
              Consumer<AttendanceViewModel>(
                builder: (_, vm, __) => AttendanceActionBanner(
                  status: vm.status,
                  isLoading: vm.isLoading,
                  onTap: () async {
                    final ok = await vm.markAttendance();
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(ok
                            ? 'Attendance updated'
                            : (vm.error ?? 'Failed'))));
                    if (ok) context.read<RouteViewModel>().loadRoutes();
                  },
                ),
              ),
              SizedBox(height: 28 * s),
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
                              builder: (_) => const RouteListScreen())),
                    ),
                  ),
                  SizedBox(width: 18 * s),
                  Expanded(
                    child: DashboardActionCard(
                      title: 'Apply Leave',
                      icon: Icons.calendar_month,
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ApplyLeaveScreen())),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 28 * s),
              Row(
                children: [
                  const Expanded(
                      child: Text('Recent Activity',
                          style: TextStyle(fontWeight: FontWeight.w800))),
                  InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const LeaveListScreen())),
                    child: const Text('View All  ›',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              SizedBox(height: 10 * s),
              Consumer<RouteViewModel>(
                builder: (_, vm, __) {
                  if (vm.isLoading) {
                    return const Center(
                        child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator()));
                  }
                  if (vm.routes.isEmpty) {
                    return const ActivityCard(
                        date: 'No recent activity',
                        subtitle: 'Your attendance records will appear here');
                  }
                  return Column(
                    children: vm.routes.take(3).map((route) {
                      return ActivityCard(
                        date: route.date.isNotEmpty ? route.date : 'Route',
                        markIn: route.markIn,
                        markOut: route.markOut,
                      );
                    }).toList(),
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
