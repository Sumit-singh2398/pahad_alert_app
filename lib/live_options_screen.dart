import 'package:flutter/material.dart';

class LiveOptionsScreen extends StatefulWidget {
  const LiveOptionsScreen({super.key});

  @override
  State<LiveOptionsScreen> createState() => _LiveOptionsScreenState();
}

class _LiveOptionsScreenState extends State<LiveOptionsScreen> {
  static const Color primaryBlue = Color(0xFF1769E0);
  static const Color darkBlue = Color(0xFF123B70);
  static const Color lightBlue = Color(0xFFF4F8FF);

  bool rain = true;
  bool landslide = true;
  bool wind = false;
  bool flood = false;
  bool roads = true;

  String distance = '10 km';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Live Tracking',
          style: TextStyle(
            color: darkBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: darkBlue),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Track What Matters',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: darkBlue,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Select the information you want to monitor around you.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            'Monitoring Options',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: darkBlue,
            ),
          ),

          const SizedBox(height: 12),

          _option(
            Icons.water_drop_outlined,
            'Rain',
            'Rainfall conditions',
            rain,
            (v) => setState(() => rain = v),
          ),

          _option(
            Icons.terrain_outlined,
            'Landslide',
            'Landslide risk information',
            landslide,
            (v) => setState(() => landslide = v),
          ),

          _option(
            Icons.air,
            'Wind',
            'Wind conditions ',
            wind,
            (v) => setState(() => wind = v),
          ),

          _option(
            Icons.flood_outlined,
            'Floods',
            'Flood information ',
            flood,
            (v) => setState(() => flood = v),
          ),

          _option(
            Icons.directions_car_outlined,
            'Roads',
            'Nearby road conditions',
            roads,
            (v) => setState(() => roads = v),
          ),

          const SizedBox(height: 25),

          const Text(
            'Around Me',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: darkBlue,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              _distanceButton('5 km'),
              const SizedBox(width: 10),
              _distanceButton('10 km'),
              const SizedBox(width: 10),
              _distanceButton('20 km'),
            ],
          ),

          const SizedBox(height: 30),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: lightBlue,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: primaryBlue,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Live tracking requires an active internet connection.',
                    style: TextStyle(
                      fontSize: 13,
                      color: darkBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _option(
    IconData icon,
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: lightBlue,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: primaryBlue,
            size: 28,
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: darkBlue,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeColor: primaryBlue,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _distanceButton(String value) {
    final selected = distance == value;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            distance = value;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            color: selected ? primaryBlue : lightBlue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? Colors.white : darkBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}