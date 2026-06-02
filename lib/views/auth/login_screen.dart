import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../viewmodels/auth_view_model.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../dashboard/dashboard_screen.dart';
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
    final s = Responsive.scale(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 28 * s),
            child: Column(
              children: [
                SizedBox(height: Responsive.h(130, context)),
                const Text('zyromate', style: TextStyle(fontSize: 42, color: AppColors.darkPrimary, fontWeight: FontWeight.w900)),
                SizedBox(height: Responsive.h(80, context)),
                CustomTextField(
                  controller: mobileController,
                  hint: 'Mobile Number',
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 16 * s),
                CustomTextField(
                  controller: passwordController,
                  hint: 'Password',
                  obscureText: true,
                ),
                SizedBox(height: 28 * s),
                Consumer<AuthViewModel>(
                  builder: (_, vm, __) => PrimaryButton(text: 'Login', isLoading: vm.isLoading, onTap: _login),
                ),
                SizedBox(height: 12 * s),
                PrimaryButton(
                  text: 'Create Account',
                  outlined: true,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
                ),
                SizedBox(height: Responsive.h(60, context)),
                const Text('Powered by Mediezy', style: TextStyle(color: AppColors.grey)),
                SizedBox(height: 24 * s),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
