import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../viewmodels/leave_view_model.dart';
import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/top_bar.dart';
import 'leave_list_screen.dart';

class ApplyLeaveScreen extends StatefulWidget {
  const ApplyLeaveScreen({super.key});

  @override
  State<ApplyLeaveScreen> createState() => _ApplyLeaveScreenState();
}

class _ApplyLeaveScreenState extends State<ApplyLeaveScreen> {
  String leaveMode = 'full_day';
  final from = TextEditingController();
  final to = TextEditingController();
  final reason = TextEditingController();
  final leaveType = TextEditingController();

  @override
  void dispose() {
    from.dispose();
    to.dispose();
    reason.dispose();
    leaveType.dispose();
    super.dispose();
  }

  Future<void> _apply() async {
    final ok = await context.read<LeaveViewModel>().applyLeave(
          leaveMode: leaveMode,
          leaveType: leaveType.text.trim(),
          startDate: from.text.trim(),
          endDate: to.text.trim(),
          reason: reason.text.trim(),
        );

    if (!mounted) return;

    final vm = context.read<LeaveViewModel>();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ok ? 'Leave applied successfully' : (vm.error ?? 'Failed'))),
    );

    if (ok) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => LeaveListScreen(
            initialFilter: 'pending',
            initialMonth: _monthFromDate(from.text.trim()),
          ),
        ),
      );
    }
  }

  String _monthFromDate(String date) {
    if (date.length >= 7 && date[4] == '-') return date.substring(5, 7);
    return DateTime.now().month.toString().padLeft(2, '0');
  }

  Future<void> _pick(TextEditingController controller) async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      initialDate: DateTime.now(),
    );
    if (date != null) {
      controller.text = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const TopBar(title: 'Apply Leave'),
              const SizedBox(height: 20),
              Container(
                height: 45,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 4)],
                ),
                child: Row(
                  children: [
                    _ModeButton(text: 'Full Day', selected: leaveMode == 'full_day', onTap: () => setState(() => leaveMode = 'full_day')),
                    _ModeButton(text: 'Half Day', selected: leaveMode == 'half_day', onTap: () => setState(() => leaveMode = 'half_day')),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 5)],
                ),
                child: Column(
                  children: [
                    AppTextField(controller: from, label: 'From', hint: 'YYYY-MM-DD', readOnly: true, onTap: () => _pick(from), suffixIcon: const Icon(Icons.calendar_month, size: 18)),
                    const SizedBox(height: 12),
                    AppTextField(controller: to, label: 'To', hint: 'YYYY-MM-DD', readOnly: true, onTap: () => _pick(to), suffixIcon: const Icon(Icons.calendar_month, size: 18)),
                    const SizedBox(height: 12),
                    AppTextField(controller: reason, label: 'Reason', hint: 'Enter Leave reason', maxLines: 3),
                    const SizedBox(height: 12),
                    AppTextField(controller: leaveType, label: 'Leave Type', hint: 'casual / sick / emergency'),
                  ],
                ),
              ),
              const Spacer(),
              Consumer<LeaveViewModel>(builder: (_, vm, __) => PrimaryButton(text: 'Apply', isLoading: vm.isLoading, onTap: _apply)),
              const SizedBox(height: 12),
              PrimaryButton(text: 'Leave List', outlined: true, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaveListScreen()))),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({required this.text, required this.selected, required this.onTap});
  final String text;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(color: selected ? AppColors.primary : Colors.transparent, borderRadius: BorderRadius.circular(24)),
          child: Text(text, style: TextStyle(fontWeight: FontWeight.w700, color: selected ? Colors.white : Colors.black)),
        ),
      ),
    );
  }
}
