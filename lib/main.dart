import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_colors.dart';
import 'core/network/api_client.dart';
import 'core/storage/local_storage_service.dart';
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
import 'views/splash/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final apiClient = ApiClient();
  final session = SessionManager();
  final localStorage = LocalStorageService();

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: session),
        Provider.value(value: localStorage),
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(AuthRepository(apiClient, session)),
        ),
        ChangeNotifierProvider(
          create: (_) => DashboardViewModel(session, localStorage),
        ),
        ChangeNotifierProvider(
          create: (_) => AttendanceViewModel(AttendanceRepository(apiClient)),
        ),
        ChangeNotifierProvider(
          create: (_) => LeaveViewModel(LeaveRepository(apiClient), session),
        ),
        ChangeNotifierProvider(
          create: (_) => RouteViewModel(RouteRepository(apiClient)),
        ),
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
      home: const SplashScreen(),
    );
  }
}
