import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/route_model.dart';

class RouteMapScreen extends StatefulWidget {
  const RouteMapScreen({super.key, required this.route});

  final RouteModel route;

  @override
  State<RouteMapScreen> createState() => _RouteMapScreenState();
}

class _RouteMapScreenState extends State<RouteMapScreen> {
  GoogleMapController? _mapController;
  final bool _mapError = false;

  bool get _hasValidLocation {
    return widget.route.latitude != 0 && widget.route.longitude != 0;
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Set<Marker> _buildMarkers() {
    final markers = <Marker>{};

    if (!_hasValidLocation) {
      return markers;
    }

    markers.add(
      Marker(
        markerId: const MarkerId('mark_in'),
        position: LatLng(widget.route.latitude, widget.route.longitude),
        infoWindow: InfoWindow(
          title: 'Mark In',
          snippet: widget.route.markIn,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );

    if (widget.route.markOutLatitude != 0 &&
        widget.route.markOutLongitude != 0) {
      markers.add(
        Marker(
          markerId: const MarkerId('mark_out'),
          position: LatLng(
            widget.route.markOutLatitude,
            widget.route.markOutLongitude,
          ),
          infoWindow: InfoWindow(
            title: 'Mark Out',
            snippet: widget.route.markOut,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }

    return markers;
  }

  Set<Polyline> _buildPolylines() {
    if (!_hasValidLocation) {
      return {};
    }

    if (widget.route.markOutLatitude == 0 &&
        widget.route.markOutLongitude == 0) {
      return {};
    }

    return {
      Polyline(
        polylineId: const PolylineId('route_line'),
        points: [
          LatLng(widget.route.latitude, widget.route.longitude),
          LatLng(
            widget.route.markOutLatitude,
            widget.route.markOutLongitude,
          ),
        ],
        color: AppColors.primary,
        width: 3,
      ),
    };
  }

  CameraPosition _initialCamera() {
    if (_hasValidLocation) {
      return CameraPosition(
        target: LatLng(widget.route.latitude, widget.route.longitude),
        zoom: 14,
      );
    }

    return const CameraPosition(
      target: LatLng(10.0261, 76.3125),
      zoom: 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = Responsive.scale(context);

    return Scaffold(
      body: Stack(
        children: [
          _buildMap(),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(Responsive.w(24, context)),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back_ios_new),
                  ),

                  SizedBox(width: 10 * s),

                  const Text(
                    'My Route',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const Spacer(),

                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.darkPrimary,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            left: Responsive.w(28, context),
            right: Responsive.w(28, context),
            bottom: Responsive.h(36, context),
            child: Container(
              padding: EdgeInsets.all(Responsive.w(16, context)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 6,
                  ),
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
                          'Route - ${widget.route.date}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        SizedBox(height: 4 * s),

                        Row(
                          children: [
                            const Icon(
                              Icons.login,
                              size: 12,
                              color: AppColors.approved,
                            ),
                            SizedBox(width: 4 * s),
                            Text(
                              widget.route.markIn,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.approved,
                              ),
                            ),
                            SizedBox(width: 12 * s),
                            const Icon(
                              Icons.logout,
                              size: 12,
                              color: AppColors.danger,
                            ),
                            SizedBox(width: 4 * s),
                            Text(
                              widget.route.markOut,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.danger,
                              ),
                            ),
                          ],
                        ),

                        if (_hasValidLocation)
                          Padding(
                            padding: EdgeInsets.only(
                              top: Responsive.h(4, context),
                            ),
                            child: Text(
                              '${widget.route.latitude.toStringAsFixed(4)}, ${widget.route.longitude.toStringAsFixed(4)}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.textGrey,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      if (_hasValidLocation) {
                        _mapController?.animateCamera(
                          CameraUpdate.newLatLng(
                            LatLng(
                              widget.route.latitude,
                              widget.route.longitude,
                            ),
                          ),
                        );
                      }
                    },
                    child: const CircleAvatar(
                      backgroundColor: AppColors.darkPrimary,
                      child: Icon(
                        Icons.my_location,
                        color: Colors.white,
                      ),
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
    if (_mapError || !_hasValidLocation) {
      return _buildFallbackMap();
    }

    try {
      return GoogleMap(
        initialCameraPosition: _initialCamera(),
        markers: _buildMarkers(),
        polylines: _buildPolylines(),
        myLocationEnabled: false,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        onMapCreated: (controller) {
          _mapController = controller;
        },
      );
    } catch (_) {
      return _buildFallbackMap();
    }
  }

  Widget _buildFallbackMap() {
    return Container(
      color: const Color(0xFFE8F5E9),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.map,
              size: 64,
              color: AppColors.primary,
            ),

            const SizedBox(height: 16),

            const Text(
              'Route Map',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),

            if (_hasValidLocation) ...[
              const SizedBox(height: 8),
              Text(
                'Mark In: ${widget.route.latitude.toStringAsFixed(4)}, ${widget.route.longitude.toStringAsFixed(4)}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textGrey,
                ),
              ),

              if (widget.route.markOutLatitude != 0 &&
                  widget.route.markOutLongitude != 0)
                Padding(
                  padding: EdgeInsets.only(
                    top: Responsive.h(4, context),
                  ),
                  child: Text(
                    'Mark Out: ${widget.route.markOutLatitude.toStringAsFixed(4)}, ${widget.route.markOutLongitude.toStringAsFixed(4)}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.textGrey,
                    ),
                  ),
                ),
            ] else
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Location coordinates not available',
                  style: TextStyle(
                    color: AppColors.textGrey,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}