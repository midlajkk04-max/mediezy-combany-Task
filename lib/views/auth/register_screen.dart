import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../viewmodels/auth_view_model.dart';
import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/top_bar.dart';

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
    for (final c in [firstName, lastName, email, address, dob, mobile, location, doj, password]) {
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account created')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.read<AuthViewModel>().error ?? 'Register failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              const TopBar(title: 'Create Account'),
              const SizedBox(height: 14),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 5)],
                  ),
                  child: ListView(
                    children: [
                      AppTextField(controller: firstName, label: 'First Name', hint: 'Enter First Name'),
                      const SizedBox(height: 10),
                      AppTextField(controller: lastName, label: 'Last Name', hint: 'Enter Last Name'),
                      const SizedBox(height: 10),
                      AppTextField(controller: email, label: 'Email', hint: 'Enter Email'),
                      const SizedBox(height: 10),
                      AppTextField(controller: address, label: 'Address', hint: 'Enter Address', maxLines: 3),
                      const SizedBox(height: 10),
                      AppTextField(controller: dob, label: 'DOB', hint: 'YYYY-MM-DD'),
                      const SizedBox(height: 10),
                      AppTextField(controller: mobile, label: 'Mobile Number', hint: 'Enter Number'),
                      const SizedBox(height: 10),
                      AppTextField(controller: location, label: 'Location', hint: 'Enter location'),
                      const SizedBox(height: 10),
                      AppTextField(controller: doj, label: 'DOJ', hint: 'Date Of Joining YYYY-MM-DD'),
                      const SizedBox(height: 10),
                      AppTextField(controller: password, label: 'Password', hint: 'Enter Password', obscureText: true),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Consumer<AuthViewModel>(builder: (_, vm, __) => PrimaryButton(text: 'Save', isLoading: vm.isLoading, onTap: _save)),
            ],
          ),
        ),
      ),
    );
  }
}
