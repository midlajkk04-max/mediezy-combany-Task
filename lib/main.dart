import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_colors.dart';
import 'core/network/api_client.dart';
import 'core/utils/session_manager.dart';
import 'data/repositories/attendance_repository.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/leave_repository.dart';
import 'data/repositories/route_repository.dart';
import 'viewmodels/attendance_view_model.dart';
import 'viewmodels/auth_view_model.dart';
import 'viewmodels/dashboard_view_model.dart';
import 'viewmodels/leave_view_model.dart';
import 'viewmodels/route_view_model.dart';
import 'views/auth/login_screen.dart';
import 'views/dashboard/dashboard_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final apiClient = ApiClient();
  final session = SessionManager();

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: session),
        ChangeNotifierProvider(create: (_) => AuthViewModel(AuthRepository(apiClient, session))),
        ChangeNotifierProvider(create: (_) => DashboardViewModel(session)),
        ChangeNotifierProvider(create: (_) => AttendanceViewModel(AttendanceRepository(apiClient))),
        ChangeNotifierProvider(create: (_) => LeaveViewModel(LeaveRepository(apiClient), session)),
        ChangeNotifierProvider(create: (_) => RouteViewModel(RouteRepository(apiClient))),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zyromate HR',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.bg,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const SplashGate(),
    );
  }
}

class SplashGate extends StatefulWidget {
  const SplashGate({super.key});

  @override
  State<SplashGate> createState() => _SplashGateState();
}

class _SplashGateState extends State<SplashGate> {
  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    final loggedIn = await context.read<SessionManager>().isLoggedIn;
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => loggedIn ? const DashboardScreen() : const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('zyromate', style: TextStyle(fontSize: 42, color: AppColors.darkPrimary, fontWeight: FontWeight.w900)),
      ),
    );
  }
}
