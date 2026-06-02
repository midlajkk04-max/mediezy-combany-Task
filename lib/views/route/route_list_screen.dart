import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/route_model.dart';
import '../../viewmodels/route_view_model.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/profile_avatar.dart';
import 'route_map_screen.dart';

class RouteListScreen extends StatefulWidget {
  const RouteListScreen({super.key});

  @override
  State<RouteListScreen> createState() => _RouteListScreenState();
}

class _RouteListScreenState extends State<RouteListScreen> {
  final searchController = TextEditingController();
  List<RouteModel> filteredRoutes = [];
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RouteViewModel>().loadRoutes().then((_) {
        if (!mounted) return;
        final routes = context.read<RouteViewModel>().routes;
        setState(() {
          filteredRoutes = List.from(routes);
          _initialized = true;
        });
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterRoutes(String query, List<RouteModel> allRoutes) {
    if (query.isEmpty) {
      filteredRoutes = List.from(allRoutes);
    } else {
      filteredRoutes = allRoutes.where((route) {
        return route.name.toLowerCase().contains(query.toLowerCase()) ||
            route.date.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const CustomAppBar(title: 'My Route'),
              const SizedBox(height: 20),
              CustomTextField(
                controller: searchController,
                hint: 'Search by date or name',
                prefixIcon: const Icon(Icons.search, size: 20),
                onChanged: (query) {
                  final vm = context.read<RouteViewModel>();
                  _filterRoutes(query, vm.routes);
                },
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () {
                          searchController.clear();
                          final vm = context.read<RouteViewModel>();
                          _filterRoutes('', vm.routes);
                        },
                      )
                    : null,
              ),
              const SizedBox(height: 14),
              Expanded(
                child: Consumer<RouteViewModel>(
                  builder: (_, vm, __) {
                    if (vm.isLoading && !_initialized) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (vm.error != null && vm.routes.isEmpty) {
                      return Center(child: Text(vm.error!));
                    }
                    if (vm.routes.isEmpty && _initialized) {
                      return const EmptyState(message: 'No routes found');
                    }
                    if (filteredRoutes.isEmpty &&
                        searchController.text.isNotEmpty) {
                      return const EmptyState(message: 'No matching routes');
                    }
                    return ListView.builder(
                      itemCount: filteredRoutes.length,
                      itemBuilder: (_, i) =>
                          _RouteCard(route: filteredRoutes[i]),
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
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => RouteMapScreen(route: route)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 4)],
        ),
        child: Row(
          children: [
            const ProfileAvatar(radius: 16, iconSize: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    route.date.isEmpty ? 'Route' : route.date,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  Text(
                    'Marked in at ${route.markIn}  |  Marked out at ${route.markOut}',
                    style: const TextStyle(fontSize: 10, color: AppColors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.grey),
          ],
        ),
      ),
    );
  }
}
