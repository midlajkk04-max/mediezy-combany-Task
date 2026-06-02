import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../viewmodels/attendance_view_model.dart';
import '../../viewmodels/dashboard_view_model.dart';
import '../attendance/attendance_history_card.dart';
import 'attendance_action_banner.dart';
import '../leave/apply_leave_screen.dart';
import '../leave/leave_list_screen.dart';
import '../route/create_route_screen.dart';

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
              const CircleAvatar(radius: 34, backgroundColor: AppColors.darkPrimary, child: Icon(Icons.person, color: Colors.white, size: 48)),
              const SizedBox(height: 12),
              Consumer<DashboardViewModel>(
                builder: (_, vm, __) => Text('Hi ${vm.name}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              ),
              const Text('Sales Executive\nErnakulam', textAlign: TextAlign.center, style: TextStyle(fontSize: 11)),
              const SizedBox(height: 24),
              Consumer<AttendanceViewModel>(
                builder: (_, vm, __) => AttendanceActionBanner(
                  status: vm.status,
                  isLoading: vm.isLoading,
                  onTap: () async {
                    final ok = await vm.markAttendance();
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(ok ? 'Attendance updated' : (vm.error ?? 'Failed'))),
                    );
                  },
                ),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(child: _Tile(title: 'Route', icon: Icons.calendar_month, dark: true, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateRouteScreen())))),
                  const SizedBox(width: 18),
                  Expanded(child: _Tile(title: 'Apply Leave', icon: Icons.calendar_month, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ApplyLeaveScreen())))),
                ],
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  const Expanded(child: Text('Recent Activity', style: TextStyle(fontWeight: FontWeight.w800))),
                  InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaveListScreen())),
                    child: const Text('View All  ›', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const AttendanceHistoryCard(date: '23 Aug 2026'),
              const AttendanceHistoryCard(date: '22 Aug 2026'),
              const AttendanceHistoryCard(date: '21 Aug 2026'),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.title, required this.icon, required this.onTap, this.dark = false});
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 105,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: dark ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 5)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(radius: 16, backgroundColor: dark ? Colors.white : AppColors.darkPrimary, child: Icon(icon, color: dark ? AppColors.darkPrimary : Colors.white, size: 18)),
            const Spacer(),
            Text(title, style: TextStyle(fontWeight: FontWeight.w800, color: dark ? Colors.white : Colors.black)),
          ],
        ),
      ),
    );
  }
}
