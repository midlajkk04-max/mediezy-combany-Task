import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/leave_model.dart';
import '../../viewmodels/leave_view_model.dart';
import '../widgets/top_bar.dart';

class LeaveListScreen extends StatefulWidget {
  const LeaveListScreen({super.key, this.initialFilter = 'all', this.initialMonth});

  final String initialFilter;
  final String? initialMonth;

  @override
  State<LeaveListScreen> createState() => _LeaveListScreenState();
}

class _LeaveListScreenState extends State<LeaveListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<LeaveViewModel>().loadLeaves(
            widget.initialFilter,
            month: widget.initialMonth,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const TopBar(title: 'Leave List'),
              const SizedBox(height: 20),
              Consumer<LeaveViewModel>(
                builder: (_, vm, __) => Row(
                  children: ['all', 'pending', 'approved', 'rejected'].map((e) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: ChoiceChip(
                          label: Text(e == 'all' ? 'All' : e[0].toUpperCase() + e.substring(1), style: const TextStyle(fontSize: 11)),
                          selected: vm.selectedFilter == e,
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(color: vm.selectedFilter == e ? Colors.white : Colors.black),
                          onSelected: (_) => vm.loadLeaves(e),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 8),
              Consumer<LeaveViewModel>(
                builder: (_, vm, __) => Text(
                  'Month: ${vm.selectedMonth}',
                  style: const TextStyle(color: AppColors.grey, fontSize: 12),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Consumer<LeaveViewModel>(
                  builder: (_, vm, __) {
                    if (vm.isLoading) return const Center(child: CircularProgressIndicator());
                    if (vm.error != null) return Center(child: Text(vm.error!));
                    if (vm.leaves.isEmpty) return const Center(child: Text('No leaves found'));
                    return ListView.builder(
                      itemCount: vm.leaves.length,
                      itemBuilder: (_, i) => _LeaveCard(leave: vm.leaves[i]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LeaveCard extends StatelessWidget {
  const _LeaveCard({required this.leave});
  final LeaveModel leave;

  Color get color {
    final s = leave.status.toLowerCase();
    if (s.contains('approved')) return AppColors.primary;
    if (s.contains('reject')) return AppColors.danger;
    return AppColors.warning;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(8), boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 4)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${leave.leaveMode} Application', style: const TextStyle(color: AppColors.grey, fontSize: 12)),
          Text(leave.startDate.isEmpty ? 'Date not available' : leave.startDate, style: const TextStyle(fontWeight: FontWeight.w800)),
          if (leave.endDate.isNotEmpty) Text('To: ${leave.endDate}', style: const TextStyle(color: AppColors.grey, fontSize: 12)),
          Text(leave.leaveType, style: const TextStyle(color: AppColors.warning, fontSize: 12)),
          if (leave.reason.isNotEmpty) Text(leave.reason, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.check_circle, color: AppColors.primary, size: 16),
              const Text(' Create ', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
              const Expanded(child: Divider()),
              const Icon(Icons.check_circle, color: AppColors.primary, size: 16),
              const Text(' Review ', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
              const Expanded(child: Divider()),
              Icon(leave.status.toLowerCase().contains('reject') ? Icons.cancel : Icons.check_circle, color: color, size: 16),
              Text(' ${leave.status}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
