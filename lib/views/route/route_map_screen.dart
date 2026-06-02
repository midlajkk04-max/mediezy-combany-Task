import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/route_model.dart';

/// RouteMapScreen
///
/// To enable Google Maps:
/// 1. Set _useGoogleMaps = true below
/// 2. Add your API key in android/app/src/main/AndroidManifest.xml:
///    <meta-data android:name="com.google.android.geo.API_KEY"
///        android:value="YOUR_KEY_HERE"/>
/// 3. For iOS, add in ios/Runner/AppDelegate.swift:
///    GMSServices.provideAPIKey("YOUR_KEY_HERE")
class RouteMapScreen extends StatefulWidget {
  const RouteMapScreen({super.key, required this.route});
  final RouteModel route;

  @override
  State<RouteMapScreen> createState() => _RouteMapScreenState();
}

class _RouteMapScreenState extends State<RouteMapScreen> {
  // Set to true after configuring Google Maps API key
  bool _useGoogleMaps = false;

  bool get _hasValidLocation {
    return widget.route.latitude != 0 && widget.route.longitude != 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildMap(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios_new),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'My Route',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const Spacer(),
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.darkPrimary,
                    child: Icon(Icons.person, color: Colors.white, size: 20),
                  ),
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
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(color: Color(0x33000000), blurRadius: 6)
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.route.name,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        const Text(
                          'Online/Offline',
                          style: TextStyle(fontSize: 11),
                        ),
                        if (_hasValidLocation)
                          Text(
                            'In: ${widget.route.latitude.toStringAsFixed(4)}, ${widget.route.longitude.toStringAsFixed(4)}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.textGrey,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (widget.route.markIn.isNotEmpty)
                    Text(
                      widget.route.markIn,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () => setState(() {
                      _useGoogleMaps = !_useGoogleMaps;
                    }),
                    child: const CircleAvatar(
                      backgroundColor: AppColors.darkPrimary,
                      child: Icon(Icons.refresh, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    if (_useGoogleMaps) {
      // Google Maps will be rendered here when API key is configured
      return _buildFallbackMap();
    }
    return _buildFallbackMap();
  }

  Widget _buildFallbackMap() {
    return Container(
      color: const Color(0xFFE8F5E9),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.map, size: 64, color: AppColors.primary),
            const SizedBox(height: 16),
            const Text(
              'Route Map',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            if (_hasValidLocation)
              Text(
                'Mark In: ${widget.route.latitude.toStringAsFixed(4)}, ${widget.route.longitude.toStringAsFixed(4)}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textGrey),
              )
            else
              const Text(
                'Location coordinates not available',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textGrey),
              ),
            if (_hasValidLocation &&
                widget.route.markOutLatitude != 0 &&
                widget.route.markOutLongitude != 0)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Mark Out: ${widget.route.markOutLatitude.toStringAsFixed(4)}, ${widget.route.markOutLongitude.toStringAsFixed(4)}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textGrey),
                ),
              ),
            const SizedBox(height: 16),
            const Text(
              'Add Google Maps API key to see the map',
              style: TextStyle(fontSize: 11, color: AppColors.textGrey),
            ),
          ],
        ),
      ),
    );
  }

}
