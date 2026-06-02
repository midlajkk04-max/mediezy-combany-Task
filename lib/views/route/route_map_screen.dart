import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/route_model.dart';

class RouteMapScreen extends StatelessWidget {
  const RouteMapScreen({super.key, required this.route});
  final RouteModel route;

  @override
  Widget build(BuildContext context) {
    final hasLocation = route.latitude != 0 && route.longitude != 0;
    final position = LatLng(hasLocation ? route.latitude : 10.0261, hasLocation ? route.longitude : 76.3125);

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: position, zoom: 14),
            markers: {
              Marker(markerId: const MarkerId('route'), position: position, infoWindow: InfoWindow(title: route.name)),
            },
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  InkWell(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back_ios_new)),
                  const SizedBox(width: 10),
                  const Text('My Route', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  const Spacer(),
                  const CircleAvatar(radius: 16, backgroundColor: AppColors.darkPrimary, child: Icon(Icons.person, color: Colors.white, size: 20)),
                ],
              ),
            ),
          ),
          Positioned(
            left: 28,
            right: 28,
            bottom: 36,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(8), boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 6)]),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(route.name, style: const TextStyle(fontWeight: FontWeight.w800)),
                        const Text('Online/Offline', style: TextStyle(fontSize: 11)),
                        const Row(children: [Icon(Icons.battery_full, color: AppColors.primary, size: 14), Text('100%', style: TextStyle(fontWeight: FontWeight.w700))]),
                      ],
                    ),
                  ),
                  const Text('253.0 Km', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                  const SizedBox(width: 12),
                  const CircleAvatar(backgroundColor: AppColors.darkPrimary, child: Icon(Icons.refresh, color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
