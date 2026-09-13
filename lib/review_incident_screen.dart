import 'package:flutter/material.dart';

class ReviewIncidentScreen extends StatelessWidget {
  final String incidentType;
  final String severity;
  final String description;
  final int photoCount;
  final bool videoAdded;

  const ReviewIncidentScreen({
    super.key,
    required this.incidentType,
    required this.severity,
    required this.description,
    required this.photoCount,
    required this.videoAdded,
  });

  static const Color primaryBlue = Color(0xFF1769E0);
  static const Color darkBlue = Color(0xFF123B70);
  static const Color lightBlue = Color(0xFFF4F8FF);

  void submitReport(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Report Submitted',
            style: TextStyle(
              color: darkBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Your incident report has been submitted successfully.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.popUntil(
                  context,
                  (route) => route.isFirst,
                );
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: primaryBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: darkBlue,
            size: 20,
          ),
        ),
        title: const Text(
          'Review Report',
          style: TextStyle(
            color: darkBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _progressBar(),

            const SizedBox(height: 30),

            const Text(
              'Review Your Report',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: darkBlue,
              ),
            ),

            const SizedBox(height: 20),

            _detailCard(
              'Incident Type',
              incidentType,
              Icons.warning_amber_outlined,
            ),

            _detailCard(
              'Severity',
              severity,
              Icons.priority_high_outlined,
            ),

            _detailCard(
              'Description',
              description,
              Icons.description_outlined,
            ),

            _detailCard(
              'Photos',
              '$photoCount photo(s) added',
              Icons.photo_library_outlined,
            ),

            _detailCard(
              'Video',
              videoAdded ? 'Video added' : 'No video added',
              Icons.videocam_outlined,
            ),

            const SizedBox(height: 25),

            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: lightBlue,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: primaryBlue,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Please review the information before submitting your incident report.',
                      style: TextStyle(
                        fontSize: 12,
                        color: darkBlue,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  submitReport(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Submit Report',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailCard(
    String title,
    String value,
    IconData icon,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: lightBlue,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: primaryBlue,
            size: 25,
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: darkBlue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _progressBar() {
    return Row(
      children: [
        _step('1', 'Details'),
        Expanded(
          child: Container(
            height: 2,
            color: primaryBlue,
          ),
        ),
        _step('2', 'Upload'),
        Expanded(
          child: Container(
            height: 2,
            color: primaryBlue,
          ),
        ),
        _step('3', 'Review'),
      ],
    );
  }

  Widget _step(
    String number,
    String title,
  ) {
    return Column(
      children: [
        Container(
          height: 36,
          width: 36,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: primaryBlue,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            color: primaryBlue,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}