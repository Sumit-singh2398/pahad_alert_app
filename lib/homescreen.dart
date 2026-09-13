import 'package:flutter/material.dart';
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

class _HomeScreenState extends State<HomeScreen> {
  bool trackLive = true;

  static const Color primaryBlue = Color(0xFF1769E0);
  static const Color darkBlue = Color(0xFF123B70);
  static const Color lightBlue = Color(0xFFF4F8FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [

        
            Container(
              height: 72,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFFE5E5E5),
                  ),
                ),
              ),
              child: Row(
                children: [

                  // PROFILE
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ProfileScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: lightBlue,
                        border: Border.all(
                          color: primaryBlue,
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: primaryBlue,
                        size: 28,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Expanded(
                    child: Text(
                      "User's Name",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: darkBlue,
                      ),
                    ),
                  ),

                  // NOTIFICATION
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const AlertsScreen(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.notifications_none,
                      color: darkBlue,
                      size: 29,
                    ),
                  ),
                ],
              ),
            ),

            
            SizedBox(
              height: 55,
              child: Row(
                children: [

                  // LANDSLIDE PREDICTION
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
                          bottom: BorderSide(
                            color: primaryBlue,
                            width: 2,
                          ),
                        ),
                      ),
                      child: const Text(
                        'Landslide Prediction',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: darkBlue,
                        ),
                      ),
                    ),
                  ),

                  // REPORT INCIDENT
                  Expanded(
                    child: GestureDetector(
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
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color(0xFFE0E0E0),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Report Landslide/Disaster',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: darkBlue,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            
            Container(
              height: 58,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFFE8E8E8),
                  ),
                ),
              ),
              child: Row(
                children: [

                  const Expanded(
                    child: Text(
                      'Track Live ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: darkBlue,
                      ),
                    ),
                  ),

                  Switch(
                    value: trackLive,
                    activeColor: const Color.fromARGB(255, 5, 87, 47),
                    onChanged: (value) {
                      setState(() {
                        trackLive = value;
                      });
                    },
                  ),

                  const SizedBox(width: 5),

                  // LIVE OPTIONS
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const LiveOptionsScreen(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.layers_outlined,
                      color: darkBlue,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),

        
            Expanded(
              child: Container(
                width: double.infinity,
                color: const Color(0xFFF4F7FA),
                child: Stack(
                  children: [

                    // MAP PLACEHOLDER
                    Center(
                      child: Container(
                        height: 300,
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(35),
                          border: Border.all(
                            color:
                                const Color.fromARGB(255, 5, 87, 47).withOpacity(0.45),
                            width: 2,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.landscape_outlined,
                            size: 100,
                            color: primaryBlue,
                          ),
                        ),
                      ),
                    ),

                    // CURRENT LOCATION BUTTON
                    Positioned(
                      top: 20,
                      right: 18,
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  const Color.fromARGB(255, 0, 0, 0).withOpacity(0.12),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.my_location,
                            color: primaryBlue,
                          ),
                        ),
                      ),
                    ),

                   
                    Positioned(
                      right: 20,
                      bottom: 25,
                      child: SizedBox(
                        width: 145,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const GetHelpScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryBlue,
                            foregroundColor: Colors.white,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(14),
                            ),
                          ),
                          icon: const Icon(
                            Icons.help_outline,
                            size: 22,
                          ),
                          label: const Text(
                            'Get Help',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}