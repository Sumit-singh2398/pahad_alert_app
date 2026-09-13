import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'report_incident_screen.dart';

class GetHelpScreen extends StatelessWidget {
  const GetHelpScreen({super.key});

  // ============================================================
  // COLORS
  // ============================================================

  static const Color primaryBlue = Color(0xFF1769E0);
  static const Color darkBlue = Color(0xFF123B70);
  static const Color background = Color(0xFFF6F8FC);
  static const Color lightBlue = Color(0xFFEAF2FF);
  static const Color textDark = Color(0xFF172033);
  static const Color textGrey = Color(0xFF6B7280);

  static const Color emergencyRed = Color(0xFFD92D20);
  static const Color lightRed = Color(0xFFFFF0EE);

  // ============================================================
  // CALL 112
  // ============================================================

  Future<void> _call112(BuildContext context) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: '112',
    );

    try {
      final bool launched = await launchUrl(phoneUri);

      if (!launched && context.mounted) {
        _showMessage(
          context,
          'Unable to open the phone dialer.',
        );
      }
    } catch (e) {
      if (context.mounted) {
        _showMessage(
          context,
          'Unable to make the call. Please dial 112 manually.',
        );
      }
    }
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: darkBlue,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: darkBlue,
            size: 21,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Get Help',
          style: TextStyle(
            color: darkBlue,
            fontSize: 21,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            16,
            4,
            16,
            30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ==================================================
              // HEADER
              // ==================================================

              const Text(
                'Emergency Assistance',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: textDark,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'Get emergency help and important safety information.',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: textGrey,
                ),
              ),

              const SizedBox(height: 20),

              // ==================================================
              // EMERGENCY 112
              // ==================================================

              _buildEmergencyCard(context),

              const SizedBox(height: 24),

              // ==================================================
              // QUICK HELP
              // ==================================================

              const Text(
                'Quick Help',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: darkBlue,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'Know what each emergency service can help you with.',
                style: TextStyle(
                  fontSize: 12,
                  color: textGrey,
                ),
              ),

              const SizedBox(height: 13),

              _buildQuickHelpList(context),

              const SizedBox(height: 24),

              // ==================================================
              // MEDICAL HELP
              // ==================================================

              _buildMedicalCard(context),

              const SizedBox(height: 14),

              // ==================================================
              // SAFE PLACES
              // ==================================================

              _buildSafePlacesCard(context),

              const SizedBox(height: 14),

              // ==================================================
              // ROAD STATUS
              // ==================================================

              _buildRoadStatusCard(context),

              const SizedBox(height: 24),

              // ==================================================
              // REPORT INCIDENT
              // ==================================================

              _buildReportCard(context),

              const SizedBox(height: 24),

              // ==================================================
              // EMERGENCY GUIDES
              // ==================================================

              const Text(
                'Emergency Guides',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: darkBlue,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'Know what to do during a disaster.',
                style: TextStyle(
                  fontSize: 12,
                  color: textGrey,
                ),
              ),

              const SizedBox(height: 13),

              _buildGuide(
                context,
                icon: Icons.terrain_rounded,
                title: 'Landslide',
                subtitle: 'What to do during a landslide',
                type: GuideType.landslide,
              ),

              _buildGuide(
                context,
                icon: Icons.water_rounded,
                title: 'Flash Flood',
                subtitle: 'Stay safe during flooding',
                type: GuideType.flood,
              ),

              _buildGuide(
                context,
                icon: Icons.home_work_outlined,
                title: 'Earthquake',
                subtitle: 'Drop, Cover and Hold',
                type: GuideType.earthquake,
              ),

              const SizedBox(height: 20),

              // ==================================================
              // OFFLINE EMERGENCY INFO
              // ==================================================

              _buildOfflineCard(),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // EMERGENCY CARD
  // ============================================================

  Widget _buildEmergencyCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: emergencyRed,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: emergencyRed.withOpacity(0.24),
            blurRadius: 20,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.sos_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),

              const SizedBox(width: 13),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      'EMERGENCY',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),

                    SizedBox(height: 3),

                    Text(
                      'Need immediate help?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          const Text(
            'Call 112 for police, fire, medical or disaster emergencies.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              height: 1.45,
            ),
          ),

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: () {
                _call112(context);
              },
              icon: const Icon(
                Icons.phone_rounded,
                size: 22,
              ),
              label: const Text(
                'CALL 112',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: emergencyRed,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          const Center(
            child: Text(
              '24×7 Emergency Assistance',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // QUICK HELP LIST
  // ============================================================

  Widget _buildQuickHelpList(BuildContext context) {
    return Column(
      children: [

        _quickHelpItem(
          context,
          title: 'Ambulance',
          points: const [
            'Tell the operator that a person needs medical help.',
            'Clearly explain your location and a nearby landmark.',
            'Mention serious injuries, unconsciousness or heavy bleeding.',
            'Keep the access route clear so medical help can reach quickly.',
          ],
        ),

        const SizedBox(height: 10),

        _quickHelpItem(
          context,
          title: 'Police',
          points: const [
            'Tell the operator that police assistance is required.',
            'Explain if there is danger, an unsafe situation or crowd trouble.',
            'Give your exact location and a nearby landmark.',
            'Police can help control the situation and coordinate emergency response.',
            'For medical treatment, ambulance or medical services are still required.',
          ],
        ),

        const SizedBox(height: 10),

        _quickHelpItem(
          context,
          title: 'Fire & Rescue',
          points: const [
            'Call for fire, smoke or a person trapped in danger.',
            'Tell the operator the exact location of the incident.',
            'Mention if people are trapped or need immediate rescue.',
            'Do not enter a burning or unstable building yourself.',
            'Keep a safe distance and follow rescue team instructions.',
          ],
        ),

        const SizedBox(height: 10),

        _quickHelpItem(
          context,
          title: 'Disaster / Rescue',
          points: const [
            'Use this for landslides, floods, road blockages or other disasters.',
            'Tell the operator what has happened and where it happened.',
            'Mention if people are trapped, injured or unable to move.',
            'Move to a safer place if the area is becoming dangerous.',
            'Follow official evacuation and rescue instructions.',
          ],
        ),
      ],
    );
  }

  // ============================================================
  // QUICK HELP ITEM
  // ============================================================

  Widget _quickHelpItem(
    BuildContext context, {
    required String title,
    required List<String> points,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 3,
          ),
          childrenPadding: const EdgeInsets.fromLTRB(
            18,
            0,
            18,
            16,
          ),
          iconColor: darkBlue,
          collapsedIconColor: darkBlue,

          title: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: textDark,
            ),
          ),

          trailing: const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 17,
          ),

          children: [

            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                14,
                13,
                14,
                14,
              ),
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  ...points.map(
                    (point) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: 9,
                        ),
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [

                            Container(
                              margin: const EdgeInsets.only(
                                top: 6,
                              ),
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: primaryBlue,
                                shape: BoxShape.circle,
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: Text(
                                point,
                                style: const TextStyle(
                                  fontSize: 12,
                                  height: 1.4,
                                  color: textDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 4),

                  // ==================================================
                  // CALL 112
                  // ==================================================

                  SizedBox(
                    width: double.infinity,
                    height: 43,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _call112(context);
                      },
                      icon: const Icon(
                        Icons.phone_rounded,
                        size: 19,
                      ),
                      label: const Text(
                        'CALL 112',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: emergencyRed,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // MEDICAL CARD
  // ============================================================

  Widget _buildMedicalCard(BuildContext context) {
    return _mainInfoCard(
      icon: Icons.local_hospital_outlined,
      title: 'Nearest Medical Help',
      subtitle:
          'Find hospitals, health centres and medical assistance near you.',
      iconBackground: lightBlue,
      iconColor: primaryBlue,
      buttonText: 'Find Nearby',
      onTap: () {
        _showComingSoon(
          context,
          'Nearby medical facilities will be connected with Maps and location services.',
        );
      },
    );
  }

  // ============================================================
  // SAFE PLACES CARD
  // ============================================================

  Widget _buildSafePlacesCard(BuildContext context) {
    return _mainInfoCard(
      icon: Icons.shield_outlined,
      title: 'Safe Places Near You',
      subtitle:
          'Find nearby relief centres and safer evacuation locations.',
      iconBackground: const Color(0xFFEFF8F2),
      iconColor: const Color(0xFF198754),
      buttonText: 'View Safe Places',
      onTap: () {
        _showComingSoon(
          context,
          'Safe shelters and evacuation points will be shown using your location and backend data.',
        );
      },
    );
  }

  // ============================================================
  // ROAD STATUS CARD
  // ============================================================

  Widget _buildRoadStatusCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [

          Row(
            children: [

              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.route_outlined,
                  color: primaryBlue,
                  size: 25,
                ),
              ),

              const SizedBox(width: 13),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      'Nearby Road Status',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: textDark,
                      ),
                    ),

                    SizedBox(height: 4),

                    Text(
                      'Check road blockages and affected routes.',
                      style: TextStyle(
                        fontSize: 11,
                        color: textGrey,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: darkBlue,
                size: 16,
              ),
            ],
          ),

          const SizedBox(height: 14),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 11,
            ),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Row(
              children: [

                Icon(
                  Icons.info_outline,
                  color: primaryBlue,
                  size: 18,
                ),

                SizedBox(width: 9),

                Expanded(
                  child: Text(
                    'Live road information will appear here after backend/API integration.',
                    style: TextStyle(
                      fontSize: 11,
                      color: textGrey,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            height: 43,
            child: OutlinedButton(
              onPressed: () {
                _showComingSoon(
                  context,
                  'Live road status will be connected with location and backend services.',
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryBlue,
                side: const BorderSide(
                  color: primaryBlue,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'View Road Status',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // COMMON INFORMATION CARD
  // ============================================================

  Widget _mainInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconBackground,
    required Color iconColor,
    required String buttonText,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [

          Row(
            children: [

              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 25,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: textDark,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: textGrey,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            height: 43,
            child: OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryBlue,
                side: const BorderSide(
                  color: primaryBlue,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // REPORT INCIDENT
  // ============================================================

  Widget _buildReportCard(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ReportIncidentScreen(),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: primaryBlue,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: primaryBlue.withOpacity(0.20),
                blurRadius: 16,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Row(
            children: [

              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.16),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.campaign_outlined,
                  color: Colors.white,
                  size: 25,
                ),
              ),

              const SizedBox(width: 13),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      'Report an Incident',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    SizedBox(height: 4),

                    Text(
                      'Landslide • Flood • Rockfall • Road Block',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
                size: 17,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // EMERGENCY GUIDE
  // ============================================================

  Widget _buildGuide(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required GuideType type,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 5,
        ),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: lightBlue,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(
            icon,
            color: primaryBlue,
            size: 23,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: textDark,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11,
              color: textGrey,
            ),
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: darkBlue,
          size: 16,
        ),
        onTap: () {
          _showGuide(context, type);
        },
      ),
    );
  }

  // ============================================================
  // GUIDE DIALOG
  // ============================================================

  void _showGuide(
    BuildContext context,
    GuideType type,
  ) {
    String title;
    IconData icon;
    List<String> points;

    switch (type) {
      case GuideType.landslide:
        title = 'Landslide Safety';
        icon = Icons.terrain_rounded;

        points = [
          'Move away from steep slopes and unstable ground.',
          'Do not try to cross moving soil, rocks or debris.',
          'Stay away from rivers, streams and drainage channels.',
          'Move towards a safer location if authorities issue an evacuation warning.',
          'After a landslide, avoid the affected area because additional movement may occur.',
        ];
        break;

      case GuideType.flood:
        title = 'Flash Flood Safety';
        icon = Icons.water_rounded;

        points = [
          'Move to higher and safer ground.',
          'Stay away from rivers, streams and rapidly flowing water.',
          'Never try to walk or drive through moving flood water.',
          'Follow official evacuation instructions.',
          'Keep your phone charged and monitor emergency alerts.',
        ];
        break;

      case GuideType.earthquake:
        title = 'Earthquake Safety';
        icon = Icons.home_work_outlined;

        points = [
          'DROP to the ground.',
          'COVER your head and body under a sturdy table or safe structure.',
          'HOLD ON until the shaking stops.',
          'Stay away from windows and objects that may fall.',
          'After the earthquake, move away from damaged buildings and follow official instructions.',
        ];
        break;
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          titlePadding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            8,
          ),
          contentPadding: const EdgeInsets.fromLTRB(
            20,
            5,
            20,
            10,
          ),
          title: Row(
            children: [

              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: primaryBlue,
                  size: 22,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: darkBlue,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...points.map(
                (point) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: 12,
                    ),
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [

                        Container(
                          margin: const EdgeInsets.only(
                            top: 5,
                          ),
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: primaryBlue,
                            shape: BoxShape.circle,
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: Text(
                            point,
                            style: const TextStyle(
                              fontSize: 12,
                              height: 1.4,
                              color: textDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),

          actionsPadding: const EdgeInsets.fromLTRB(
            20,
            0,
            20,
            15,
          ),

          actions: [
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Got it',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // OFFLINE CARD
  // ============================================================

  Widget _buildOfflineCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: lightBlue,
        borderRadius: BorderRadius.circular(19),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.signal_cellular_alt_rounded,
              color: primaryBlue,
              size: 22,
            ),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  'Emergency information',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: darkBlue,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  'Basic emergency guidance remains available even when internet connectivity is unavailable.',
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.4,
                    color: textGrey,
                  ),
                ),

                SizedBox(height: 8),

                Text(
                  'Emergency Number: 112',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: primaryBlue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // COMING SOON MESSAGE
  // ============================================================

  void _showComingSoon(
    BuildContext context,
    String message,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              20,
              20,
              24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                Container(
                  width: 42,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 22),

                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: lightBlue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.location_on_outlined,
                    color: primaryBlue,
                    size: 27,
                  ),
                ),

                const SizedBox(height: 14),

                const Text(
                  'Location Service',
                  style: TextStyle(
                    color: darkBlue,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: textGrey,
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),

                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(sheetContext);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    child: const Text(
                      'Okay',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ============================================================
// GUIDE TYPE
// ============================================================

enum GuideType {
  landslide,
  flood,
  earthquake,
}