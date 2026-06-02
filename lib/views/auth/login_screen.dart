import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../viewmodels/auth_view_model.dart';
import '../dashboard/dashboard_screen.dart';
import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    mobileController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final vm = context.read<AuthViewModel>();
    final ok = await vm.login(mobileController.text, passwordController.text);
    if (!mounted) return;
    if (ok) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(vm.error ?? 'Login failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 130),
              const Text('zyromate', style: TextStyle(fontSize: 42, color: AppColors.darkPrimary, fontWeight: FontWeight.w900)),
              const Spacer(),
              AppTextField(
                controller: mobileController,
                hint: 'Mobile Number',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: passwordController,
                hint: 'Password',
                obscureText: true,
              ),
              const SizedBox(height: 28),
              Consumer<AuthViewModel>(
                builder: (_, vm, __) => PrimaryButton(text: 'Login', isLoading: vm.isLoading, onTap: _login),
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                text: 'Create Account',
                outlined: true,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
              ),
              const Spacer(),
              const Text('Powered by Mediezy', style: TextStyle(color: AppColors.grey)),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
