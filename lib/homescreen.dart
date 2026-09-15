import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:arcgis_maps/arcgis_maps.dart';

import 'profile_screen.dart';
import 'alerts_screen.dart';
import 'live_options_screen.dart';
import 'get_help_screen.dart';
import 'report_incident_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  static const Color primaryBlue = Color(0xFF1769E0);
  static const Color darkBlue = Color(0xFF123B70);
  static const Color background = Color(0xFFF6F8FC);
  static const Color textDark = Color(0xFF172033);
  static const Color textGrey = Color(0xFF6B7280);
  static const Color emergencyRed = Color(0xFFE53935);
  static const Color emergencyDarkRed = Color(0xFFD32F2F);

  late final ArcGISMapViewController _mapController;
  late final GraphicsOverlay _landslideOverlay;
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;

  bool trackLive = false;

  final List<Map<String, dynamic>> _dummyLandslideData = [
    {
      'location': 'Gangtok',
      'latitude': 27.3389,
      'longitude': 88.6139,
      'risk': 'HIGH',
      'rainfall': '145 mm',
      'soilMoisture': '82%',
      'slope': '41°',
    },
    {
      'location': 'Mangan',
      'latitude': 27.5000,
      'longitude': 88.5333,
      'risk': 'HIGH',
      'rainfall': '168 mm',
      'soilMoisture': '88%',
      'slope': '46°',
    },
    {
      'location': 'Namchi',
      'latitude': 27.1667,
      'longitude': 88.3500,
      'risk': 'MODERATE',
      'rainfall': '92 mm',
      'soilMoisture': '67%',
      'slope': '32°',
    },
    {
      'location': 'Singtam',
      'latitude': 27.2333,
      'longitude': 88.5000,
      'risk': 'MODERATE',
      'rainfall': '81 mm',
      'soilMoisture': '61%',
      'slope': '29°',
    },
    {
      'location': 'Ravangla',
      'latitude': 27.3000,
      'longitude': 88.3667,
      'risk': 'LOW',
      'rainfall': '38 mm',
      'soilMoisture': '42%',
      'slope': '18°',
    },
  ];

  @override
  void initState() {
    super.initState();

    _mapController = ArcGISMapView.createController();
    _landslideOverlay = GraphicsOverlay();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.98,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.repeat(reverse: true);
  }

  void _onMapReady() {
    final map = ArcGISMap.withBasemapStyle(
      BasemapStyle.arcGISTopographic,
    );

    _mapController.arcGISMap = map;

    if (!_mapController.graphicsOverlays.contains(
      _landslideOverlay,
    )) {
      _mapController.graphicsOverlays.add(
        _landslideOverlay,
      );
    }

    _addDummyLandslideData();
    _setGangtokViewpoint();
  }

  void _addDummyLandslideData() {
    _landslideOverlay.graphics.clear();

    for (final item in _dummyLandslideData) {
      final double latitude = item['latitude'];
      final double longitude = item['longitude'];
      final String risk = item['risk'];

      Color color;
      double zoneSize;
      double markerSize;

      if (risk == 'HIGH') {
        color = Colors.red;
        zoneSize = 48;
        markerSize = 15;
      } else if (risk == 'MODERATE') {
        color = Colors.orange;
        zoneSize = 40;
        markerSize = 14;
      } else {
        color = Colors.green;
        zoneSize = 32;
        markerSize = 13;
      }

      final point = ArcGISPoint(
        x: longitude,
        y: latitude,
        spatialReference: SpatialReference.wgs84,
      );

      final zoneSymbol = SimpleMarkerSymbol(
        style: SimpleMarkerSymbolStyle.circle,
        color: color.withOpacity(0.28),
        size: zoneSize,
      );

      final zoneGraphic = Graphic(
        geometry: point,
        symbol: zoneSymbol,
      );

      zoneGraphic.attributes['location'] = item['location'];
      zoneGraphic.attributes['risk'] = risk;
      zoneGraphic.attributes['rainfall'] = item['rainfall'];
      zoneGraphic.attributes['soilMoisture'] =
          item['soilMoisture'];
      zoneGraphic.attributes['slope'] = item['slope'];

      _landslideOverlay.graphics.add(zoneGraphic);

      final markerSymbol = SimpleMarkerSymbol(
        style: SimpleMarkerSymbolStyle.circle,
        color: color,
        size: markerSize,
      );

      final markerGraphic = Graphic(
        geometry: point,
        symbol: markerSymbol,
      );

      markerGraphic.attributes['location'] = item['location'];
      markerGraphic.attributes['risk'] = risk;

      _landslideOverlay.graphics.add(markerGraphic);
    }
  }

  void _setGangtokViewpoint() {
    final point = ArcGISPoint(
      x: 88.4700,
      y: 27.3400,
      spatialReference: SpatialReference.wgs84,
    );

    final viewpoint = Viewpoint.fromCenter(
      point,
      scale: 380000,
    );

    _mapController.setViewpoint(viewpoint);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                16,
                14,
                16,
                24,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 38,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 22),
                    _buildActionCards(),
                    const SizedBox(height: 18),
                    _buildTrackLiveCard(),
                    const SizedBox(height: 18),
                    _buildMapCard(),
                    const SizedBox(height: 18),
                    _buildGetHelpCard(),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileScreen(),
              ),
            );
          },
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryBlue,
                  boxShadow: [
                    BoxShadow(
                      color: primaryBlue.withOpacity(0.22),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'S',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, Sumit 👋',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: textDark,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Stay safe, stay aware',
                    style: TextStyle(
                      fontSize: 12,
                      color: textGrey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AlertsScreen(),
              ),
            );
          },
          child: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey.shade200,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.notifications_none_rounded,
                color: darkBlue,
                size: 25,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCards() {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildPredictionCard(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildReportCard(),
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionCard() {
    return Container(
      height: 155,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1769E0),
            Color(0xFF0D55C7),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'DEMO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          const Text(
            'Landslide',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Text(
            'Prediction',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Risk monitoring',
            style: TextStyle(
              color: Colors.white.withOpacity(0.75),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const ReportIncidentScreen(),
            ),
          );
        },
        child: Container(
          height: 155,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: Colors.grey.shade200,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 16,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF2FF),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      color: primaryBlue,
                      size: 22,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF2F6FD),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      color: darkBlue,
                      size: 17,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Text(
                'Report',
                style: TextStyle(
                  color: textDark,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Text(
                'Landslide / Disaster',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: textDark,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Help your community',
                style: TextStyle(
                  color: textGrey,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrackLiveCard() {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF2FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.radar_rounded,
              color: primaryBlue,
              size: 23,
            ),
          ),
          const SizedBox(width: 11),
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Track Live',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: textDark,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Monitor nearby risk & conditions',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    color: textGrey,
                  ),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.78,
            child: Switch(
              value: trackLive,
              activeColor: primaryBlue,
              onChanged: (value) {
                setState(() {
                  trackLive = value;
                });
              },
            ),
          ),
          const SizedBox(width: 2),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const LiveOptionsScreen(),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.more_vert_rounded,
                  color: darkBlue,
                  size: 23,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapCard() {
    return Container(
      width: double.infinity,
      height: 390,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFE9EDF3),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ArcGISMapView(
              controllerProvider: () => _mapController,
              onMapViewReady: _onMapReady,
            ),
          ),
          Positioned(
            top: 14,
            left: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: primaryBlue,
                    size: 17,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Landslide Risk Map',
                    style: TextStyle(
                      color: textDark,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 14,
            right: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.science_outlined,
                    size: 14,
                    color: Colors.orange,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'DEMO DATA',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: textDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 14,
            bottom: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Risk Level',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: textDark,
                    ),
                  ),
                  SizedBox(height: 7),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _LegendDot(color: Colors.red),
                      SizedBox(width: 5),
                      Text(
                        'High',
                        style: TextStyle(
                          fontSize: 10,
                          color: textDark,
                        ),
                      ),
                      SizedBox(width: 10),
                      _LegendDot(color: Colors.orange),
                      SizedBox(width: 5),
                      Text(
                        'Moderate',
                        style: TextStyle(
                          fontSize: 10,
                          color: textDark,
                        ),
                      ),
                      SizedBox(width: 10),
                      _LegendDot(color: Colors.green),
                      SizedBox(width: 5),
                      Text(
                        'Low',
                        style: TextStyle(
                          fontSize: 10,
                          color: textDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 14,
            bottom: 14,
            child: Material(
              color: Colors.white,
              elevation: 4,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: _setGangtokViewpoint,
                child: const SizedBox(
                  width: 48,
                  height: 48,
                  child: Icon(
                    Icons.my_location_rounded,
                    color: primaryBlue,
                    size: 23,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGetHelpCard() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const GetHelpScreen(),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          height: 82,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                emergencyRed,
                emergencyDarkRed,
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: emergencyRed.withOpacity(0.28),
                blurRadius: 16,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.25),
                  ),
                ),
                child: const Icon(
                  Icons.phone_in_talk_rounded,
                  color: Colors.white,
                  size: 27,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Get Help',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Emergency & assistance',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 21,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;

  const _LegendDot({
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}