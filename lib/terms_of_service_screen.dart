import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

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
        crossAxisAlignment: CrossAxisAlignment.start,
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
          'Terms of Service',
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
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFFE1E7EF),
                  ),
                ),
                child: const Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.description_outlined,
                      color: primaryBlue,
                      size: 27,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Please read these terms before using PahadAlert.',
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.45,
                          color: textDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              sectionTitle('1. About PahadAlert'),

              paragraph(
                'PahadAlert is a citizen-focused disaster '
                'awareness and landslide risk monitoring '
                'application designed to provide safety '
                'information, alerts, reporting features '
                'and emergency assistance options.',
              ),

              sectionTitle('2. Use of the Application'),

              paragraph(
                'You agree to use PahadAlert only for '
                'lawful purposes and in a responsible manner.',
              ),

              const SizedBox(height: 9),

              bullet(
                'Provide accurate information when creating an account.',
              ),
              bullet(
                'Do not submit false or intentionally misleading incident reports.',
              ),
              bullet(
                'Do not misuse emergency or reporting features.',
              ),
              bullet(
                'Do not attempt to interfere with the operation or security of the application.',
              ),

              sectionTitle('3. Alerts and Risk Information'),

              paragraph(
                'Risk levels, rainfall information, warnings '
                'and other safety information provided by '
                'the application are intended to support '
                'awareness and decision-making. They should '
                'not be treated as a guarantee that a landslide '
                'or other disaster will or will not occur.',
              ),

              sectionTitle('4. Incident Reports'),

              paragraph(
                'Users may submit photographs, videos, '
                'descriptions and other information about '
                'possible landslides or disasters. Reports '
                'may be reviewed or verified before being '
                'used for official or analytical purposes.',
              ),

              sectionTitle('5. Emergency Situations'),

              paragraph(
                'In an emergency, users should contact the '
                'appropriate emergency services or local '
                'authorities. PahadAlert should not be '
                'considered a replacement for emergency '
                'services or official instructions.',
              ),

              sectionTitle('6. Account Responsibility'),

              paragraph(
                'You are responsible for keeping your '
                'account information secure and for all '
                'activity performed through your account.',
              ),

              sectionTitle('7. Changes to the Service'),

              paragraph(
                'Features, information and services may be '
                'updated, modified or discontinued as the '
                'application develops.',
              ),

              sectionTitle('8. Acceptance'),

              paragraph(
                'By using PahadAlert, you acknowledge that '
                'you have read and understood these Terms '
                'of Service and agree to use the application '
                'responsibly.',
              ),

              const SizedBox(height: 25),

              Center(
                child: Text(
                  'PahadAlert • Terms of Service',
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