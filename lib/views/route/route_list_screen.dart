import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/route_model.dart';
import '../../viewmodels/route_view_model.dart';
import '../widgets/top_bar.dart';
import 'route_map_screen.dart';

class RouteListScreen extends StatefulWidget {
  const RouteListScreen({super.key});

  @override
  State<RouteListScreen> createState() => _RouteListScreenState();
}

class _RouteListScreenState extends State<RouteListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<RouteViewModel>().loadRoutes());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const TopBar(title: 'My Route'),
              const SizedBox(height: 20),
              Container(
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(border: Border.all(color: AppColors.darkPrimary), borderRadius: BorderRadius.circular(18)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Expanded(child: Text('Search', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))), Icon(Icons.close, size: 18), SizedBox(width: 10)],
                ),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: Consumer<RouteViewModel>(
                  builder: (_, vm, __) {
                    if (vm.isLoading) return const Center(child: CircularProgressIndicator());
                    if (vm.error != null) return Center(child: Text(vm.error!));
                    if (vm.routes.isEmpty) return const Center(child: Text('No routes found'));
                    return ListView.builder(
                      itemCount: vm.routes.length,
                      itemBuilder: (_, i) => _RouteCard(route: vm.routes[i]),
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

class _RouteCard extends StatelessWidget {
  const _RouteCard({required this.route});
  final RouteModel route;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RouteMapScreen(route: route))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(8), boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 4)]),
        child: Row(
          children: [
            const CircleAvatar(radius: 16, backgroundColor: AppColors.darkPrimary, child: Icon(Icons.person, color: Colors.white, size: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(route.date.isEmpty ? 'Route' : route.date, style: const TextStyle(fontWeight: FontWeight.w800)),
                  Text('Marked in at ${route.markIn}  |  Marked out at ${route.markOut}', style: const TextStyle(fontSize: 10, color: AppColors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
