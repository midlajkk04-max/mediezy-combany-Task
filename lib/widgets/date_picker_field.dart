import 'package:flutter/material.dart';
import 'custom_text_field.dart';

class DatePickerField extends StatelessWidget {
  const DatePickerField({
    super.key,
    required this.controller,
    required this.label,
    required this.onPick,
    this.hint = 'YYYY-MM-DD',
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final void Function(TextEditingController controller) onPick;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      label: label,
      hint: hint,
      readOnly: true,
      onTap: () => onPick(controller),
      suffixIcon: const Icon(Icons.calendar_month, size: 18),
    );
  }
}

Future<void> pickDate({
  required BuildContext context,
  required TextEditingController controller,
  DateTime? firstDate,
  DateTime? lastDate,
  DateTime? initialDate,
}) async {
  final date = await showDatePicker(
    context: context,
    firstDate: firstDate ?? DateTime(2020),
    lastDate: lastDate ?? DateTime(2035),
    initialDate: initialDate ?? DateTime.now(),
  );
  if (date != null) {
    controller.text =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
