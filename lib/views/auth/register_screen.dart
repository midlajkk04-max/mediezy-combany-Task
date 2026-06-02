import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../viewmodels/auth_view_model.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/date_picker_field.dart';
import '../../widgets/primary_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final address = TextEditingController();
  final dob = TextEditingController();
  final mobile = TextEditingController();
  final location = TextEditingController();
  final doj = TextEditingController();
  final password = TextEditingController();

  @override
  void dispose() {
    for (final c in [
      firstName,
      lastName,
      email,
      address,
      dob,
      mobile,
      location,
      doj,
      password
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final body = {
      'first_name': firstName.text.trim(),
      'last_name': lastName.text.trim(),
      'email': email.text.trim(),
      'password': password.text.trim(),
      'address': address.text.trim(),
      'dob': dob.text.trim(),
      'mobile_number': mobile.text.trim(),
      'doj': doj.text.trim(),
      'location': location.text.trim(),
    };
    final ok = await context.read<AuthViewModel>().register(body);
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                context.read<AuthViewModel>().error ?? 'Registration failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = Responsive.scale(context);
    final gap = SizedBox(height: 10 * s);
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Responsive.w(22, context)),
          child: Column(
            children: [
              const CustomAppBar(title: 'Create Account'),
              SizedBox(height: 14 * s),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16 * s),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(color: Color(0x22000000), blurRadius: 5)
                    ],
                  ),
                  child: ListView(
                    children: [
                      CustomTextField(
                          controller: firstName,
                          label: 'First Name',
                          hint: 'Enter First Name'),
                      gap,
                      CustomTextField(
                          controller: lastName,
                          label: 'Last Name',
                          hint: 'Enter Last Name'),
                      gap,
                      CustomTextField(
                          controller: email,
                          label: 'Email',
                          hint: 'Enter Email'),
                      gap,
                      CustomTextField(
                          controller: address,
                          label: 'Address',
                          hint: 'Enter Address',
                          maxLines: 3),
                      gap,
                      DatePickerField(
                          controller: dob,
                          label: 'DOB',
                          onPick: (c) =>
                              pickDate(context: context, controller: c)),
                      gap,
                      CustomTextField(
                          controller: mobile,
                          label: 'Mobile Number',
                          hint: 'Enter Number',
                          keyboardType: TextInputType.phone),
                      gap,
                      CustomTextField(
                          controller: location,
                          label: 'Location',
                          hint: 'Enter location'),
                      gap,
                      DatePickerField(
                          controller: doj,
                          label: 'DOJ',
                          hint: 'Date Of Joining',
                          onPick: (c) =>
                              pickDate(context: context, controller: c)),
                      gap,
                      CustomTextField(
                          controller: password,
                          label: 'Password',
                          hint: 'Enter Password',
                          obscureText: true),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 18 * s),
              Consumer<AuthViewModel>(
                builder: (_, vm, __) => PrimaryButton(
                    text: 'Save', isLoading: vm.isLoading, onTap: _save),
              ),
              SizedBox(height: 24 * s),
            ],
          ),
        ),
      ),
    );
  }
}
