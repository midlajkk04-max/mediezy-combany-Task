import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../viewmodels/attendance_view_model.dart';
import '../widgets/primary_button.dart';
import '../widgets/top_bar.dart';
import 'route_list_screen.dart';

class CreateRouteScreen extends StatefulWidget {
  const CreateRouteScreen({super.key});

  @override
  State<CreateRouteScreen> createState() => _CreateRouteScreenState();
}

class _CreateRouteScreenState extends State<CreateRouteScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AttendanceViewModel>().loadStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Consumer<AttendanceViewModel>(
            builder: (_, vm, __) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TopBar(title: 'Create Route'),
                  const SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 5)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          radius: 24,
                          backgroundColor: AppColors.darkPrimary,
                          child: Icon(Icons.route, color: Colors.white),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          vm.status.isMarkedIn ? 'Route Started' : 'Start Your Route',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          vm.status.isMarkedIn
                              ? 'Attendance is marked in. Route tracking/list can be viewed now.'
                              : 'Tap Start Route. App will send current latitude and longitude using attendance/mark API.',
                          style: const TextStyle(color: AppColors.grey, height: 1.4),
                        ),
                        if (vm.error != null) ...[
                          const SizedBox(height: 14),
                          Text(vm.error!, style: const TextStyle(color: Colors.red)),
                        ],
                      ],
                    ),
                  ),
                  const Spacer(),
                  PrimaryButton(
                    text: vm.isLoading
                        ? 'Please wait...'
                        : vm.status.isMarkedIn
                            ? 'Stop Route / Mark Out'
                            : 'Start Route / Mark In',
                    onTap: vm.isLoading
                        ? null
                        : () async {
                            final ok = await vm.markAttendance();
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(ok ? 'Route attendance updated' : (vm.error ?? 'Failed'))),
                            );
                          },
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      side: const BorderSide(color: AppColors.darkPrimary, width: 1.5),
                    ),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RouteListScreen())),
                    child: const Text('Route List / My Route', style: TextStyle(color: AppColors.darkPrimary, fontWeight: FontWeight.w800)),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
