import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/date_utils.dart';
import '../../data/models/leave_model.dart';
import '../../viewmodels/leave_view_model.dart';
import '../../widgets/status_chip.dart';
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
      backgroundColor: AppColors.bg,
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
                          label: Text(
                            e == 'all'
                                ? 'All'
                                : e[0].toUpperCase() + e.substring(1),
                            style: const TextStyle(fontSize: 11),
                          ),
                          selected: vm.selectedFilter == e,
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: vm.selectedFilter == e
                                ? Colors.white
                                : Colors.black,
                          ),
                          onSelected: (_) => vm.loadLeaves(e),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
              Consumer<LeaveViewModel>(
                builder: (_, vm, __) => Row(
                  children: [
                    const Text(
                      'Your Leave',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${vm.leaves.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      height: 32,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primary),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: vm.selectedMonth,
                          isDense: true,
                          items: DateFormatUtils.months.map((name) {
                            return DropdownMenuItem(
                              value: name,
                              child: Text(
                                name.substring(0, 3),
                                style: const TextStyle(fontSize: 12),
                              ),
                            );
                          }).toList(),
                          onChanged: (v) {
                            if (v != null) vm.loadLeaves(vm.selectedFilter, month: v);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Consumer<LeaveViewModel>(
                  builder: (_, vm, __) {
                    if (vm.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (vm.error != null) {
                      return Center(child: Text(vm.error!));
                    }
                    if (vm.leaves.isEmpty) {
                      return const Center(child: Text('No leaves found'));
                    }
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${leave.leaveMode} Application',
                style: const TextStyle(
                  color: AppColors.grey,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              StatusChip(status: leave.status),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            leave.startDate.isEmpty ? 'Date not available' : leave.startDate,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          if (leave.endDate.isNotEmpty)
            Text(
              'To: ${leave.endDate}',
              style: const TextStyle(color: AppColors.grey, fontSize: 12),
            ),
          Text(
            leave.leaveType,
            style: const TextStyle(color: AppColors.warning, fontSize: 12),
          ),
          if (leave.reason.isNotEmpty)
            Text(leave.reason, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.check_circle, color: AppColors.approved, size: 16),
              const Text(
                ' Create ',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
              ),
              const Expanded(child: Divider()),
              const Icon(Icons.check_circle, color: AppColors.approved, size: 16),
              const Text(
                ' Review ',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
              ),
              const Expanded(child: Divider()),
              Icon(
                leave.status.toLowerCase().contains('reject')
                    ? Icons.cancel
                    : leave.status.toLowerCase().contains('approved')
                        ? Icons.check_circle
                        : Icons.schedule,
                color: leave.status.toLowerCase().contains('approved')
                    ? AppColors.approved
                    : leave.status.toLowerCase().contains('reject')
                        ? AppColors.danger
                        : AppColors.warning,
                size: 16,
              ),
              Text(
                ' ${leave.status}',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
