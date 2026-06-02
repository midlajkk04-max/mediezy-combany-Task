import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../viewmodels/leave_view_model.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/date_picker_field.dart';
import '../../widgets/primary_button.dart';
import 'leave_list_screen.dart';

class ApplyLeaveScreen extends StatefulWidget {
  const ApplyLeaveScreen({super.key});

  @override
  State<ApplyLeaveScreen> createState() => _ApplyLeaveScreenState();
}

class _ApplyLeaveScreenState extends State<ApplyLeaveScreen> {
  String leaveMode = 'full_day';
  String selectedLeaveType = 'casual';
  final from = TextEditingController();
  final to = TextEditingController();
  final reason = TextEditingController();

  final List<String> leaveTypes = [
    'casual',
    'sick',
    'emergency',
    'annual',
    'personal'
  ];

  @override
  void dispose() {
    from.dispose();
    to.dispose();
    reason.dispose();
    super.dispose();
  }

  Future<void> _apply() async {
    if (from.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select from date')));
      return;
    }
    if (to.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please select to date')));
      return;
    }
    if (reason.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please enter a reason')));
      return;
    }
    final ok = await context.read<LeaveViewModel>().applyLeave(
          leaveMode: leaveMode,
          leaveType: selectedLeaveType,
          startDate: from.text.trim(),
          endDate: to.text.trim(),
          reason: reason.text.trim(),
        );
    if (!mounted) return;
    final vm = context.read<LeaveViewModel>();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text(ok ? 'Leave applied successfully' : (vm.error ?? 'Failed'))),
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
    try {
      return DateFormat('MMMM').format(DateTime.parse(date));
    } catch (_) {
      return DateFormat('MMMM').format(DateTime.now());
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = Responsive.scale(context);
    final gap = SizedBox(height: 12 * s);
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Responsive.w(24, context)),
          child: Column(
            children: [
              const CustomAppBar(title: 'Apply Leave'),
              SizedBox(height: 20 * s),
              Container(
                height: 45 * s,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(color: Color(0x22000000), blurRadius: 4)
                  ],
                ),
                child: Row(
                  children: [
                    _ModeButton(
                        text: 'Full Day',
                        selected: leaveMode == 'full_day',
                        onTap: () => setState(() => leaveMode = 'full_day')),
                    _ModeButton(
                        text: 'Half Day',
                        selected: leaveMode == 'half_day',
                        onTap: () => setState(() => leaveMode = 'half_day')),
                  ],
                ),
              ),
              SizedBox(height: 20 * s),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(16 * s),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(color: Color(0x22000000), blurRadius: 5)
                      ],
                    ),
                    child: Column(
                      children: [
                        DatePickerField(
                            controller: from,
                            label: 'From',
                            onPick: (c) =>
                                pickDate(context: context, controller: c)),
                        gap,
                        DatePickerField(
                            controller: to,
                            label: 'To',
                            onPick: (c) =>
                                pickDate(context: context, controller: c)),
                        gap,
                        CustomTextField(
                            controller: reason,
                            label: 'Reason',
                            hint: 'Enter Leave reason',
                            maxLines: 3),
                        gap,
                        _LeaveTypeDropdown(
                            value: selectedLeaveType,
                            items: leaveTypes,
                            onChanged: (v) =>
                                setState(() => selectedLeaveType = v!)),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12 * s),
              Consumer<LeaveViewModel>(
                builder: (_, vm, __) => PrimaryButton(
                    text: 'Apply', isLoading: vm.isLoading, onTap: _apply),
              ),
              SizedBox(height: 12 * s),
              PrimaryButton(
                text: 'Leave List',
                outlined: true,
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const LeaveListScreen())),
              ),
              SizedBox(height: 32 * s),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton(
      {required this.text, required this.selected, required this.onTap});
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
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            text,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}

class _LeaveTypeDropdown extends StatelessWidget {
  const _LeaveTypeDropdown(
      {required this.value, required this.items, required this.onChanged});
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Leave Type',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        SizedBox(height: 6 * Responsive.scale(context)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              items: items.map((e) {
                return DropdownMenuItem(
                    value: e,
                    child: Text(e[0].toUpperCase() + e.substring(1),
                        style: const TextStyle(color: Colors.black87)));
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
