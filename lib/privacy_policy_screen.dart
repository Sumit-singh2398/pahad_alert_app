import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  static const Color primaryBlue = Color(0xFF1769E0);
  static const Color darkBlue = Color(0xFF123B70);
  static const Color textDark = Color(0xFF172033);
  static const Color textGrey = Color(0xFF667085);
  static const Color background = Color(0xFFF7F9FC);

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 22,
        bottom: 8,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: darkBlue,
        ),
      ),
    );
  }

  Widget paragraph(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        height: 1.55,
        color: textGrey,
      ),
    );
  }

  Widget bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(
              Icons.circle,
              size: 5,
              color: primaryBlue,
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                height: 1.5,
                color: textGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: textDark,
          ),
        ),
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            color: textDark,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            35,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F6FF),
                  borderRadius:
                      BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFFDCEAFF),
                  ),
                ),
                child: const Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lock_outline_rounded,
                      color: primaryBlue,
                      size: 27,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your privacy and personal information matter to us.',
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.45,
                          color: darkBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              sectionTitle('1. Information We Collect'),

              paragraph(
                'Depending on the features you use, '
                'PahadAlert may collect information required '
                'to provide its services.',
              ),

              const SizedBox(height: 9),

              bullet(
                'Name and basic profile information.',
              ),
              bullet(
                'Mobile phone number used for account verification.',
              ),
              bullet(
                'Location information when location-based features are enabled.',
              ),
              bullet(
                'Photos, videos and descriptions submitted through incident reporting.',
              ),
              bullet(
                'Notification preferences and application settings.',
              ),

              sectionTitle('2. Location Information'),

              paragraph(
                'Location information may be used to provide '
                'location-based risk information, nearby alerts, '
                'live tracking and other safety-related features. '
                'Location access is controlled through your device '
                'permissions.',
              ),

              sectionTitle('3. How We Use Information'),

              paragraph(
                'Information may be used to:',
              ),

              const SizedBox(height: 9),

              bullet(
                'Provide and improve PahadAlert services.',
              ),
              bullet(
                'Send relevant safety notifications and alerts.',
              ),
              bullet(
                'Display location-based risk information.',
              ),
              bullet(
                'Process and review citizen incident reports.',
              ),
              bullet(
                'Maintain account security and application functionality.',
              ),

              sectionTitle('4. Photos and Videos'),

              paragraph(
                'If you submit photographs or videos through '
                'the incident reporting feature, they may be '
                'stored and reviewed for incident verification '
                'and disaster monitoring purposes.',
              ),

              sectionTitle('5. Notifications'),

              paragraph(
                'If notification permission is enabled, '
                'PahadAlert may send safety alerts, incident '
                'updates and other relevant notifications.',
              ),

              sectionTitle('6. Data Security'),

              paragraph(
                'Reasonable technical and organizational '
                'measures should be used to protect information '
                'from unauthorized access, alteration or misuse. '
                'However, no digital system can guarantee absolute security.',
              ),

              sectionTitle('7. Sharing of Information'),

              paragraph(
                'Information may be shared with authorized '
                'disaster-management or emergency-response '
                'systems where necessary for safety, verification '
                'or service operation, subject to applicable rules '
                'and permissions.',
              ),

              sectionTitle('8. Your Permissions'),

              paragraph(
                'You can manage application permissions such as '
                'location, camera, photos, SMS and notifications '
                'through your device settings, subject to the '
                'features that require those permissions.',
              ),

              sectionTitle('9. Policy Updates'),

              paragraph(
                'This Privacy Policy may be updated when the '
                'application, its features or applicable requirements '
                'change. The latest version should be reviewed before '
                'continued use of the service.',
              ),

              sectionTitle('10. Contact'),

              paragraph(
                'For privacy-related questions or concerns, '
                'please use the support/contact option provided '
                'within the PahadAlert application.',
              ),

              const SizedBox(height: 25),

              Center(
                child: Text(
                  'PahadAlert • Privacy Policy',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}