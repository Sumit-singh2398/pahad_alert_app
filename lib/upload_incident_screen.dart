import 'package:flutter/material.dart';
import 'review_incident_screen.dart';

class UploadIncidentScreen extends StatefulWidget {
  final String incidentType;
  final String severity;
  final String description;

  const UploadIncidentScreen({
    super.key,
    required this.incidentType,
    required this.severity,
    required this.description,
  });

  @override
  State<UploadIncidentScreen> createState() =>
      _UploadIncidentScreenState();
}

class _UploadIncidentScreenState
    extends State<UploadIncidentScreen> {
  static const Color primaryBlue = Color(0xFF1769E0);
  static const Color darkBlue = Color(0xFF123B70);
  static const Color lightBlue = Color(0xFFF4F8FF);

  int photoCount = 0;
  bool videoAdded = false;

  void nextPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewIncidentScreen(
          incidentType: widget.incidentType,
          severity: widget.severity,
          description: widget.description,
          photoCount: photoCount,
          videoAdded: videoAdded,
        ),
      ),
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
          'Upload Media',
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
              'Upload Evidence',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: darkBlue,
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              'Add photos or video of the incident.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'Photos',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: darkBlue,
              ),
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ...List.generate(
                  photoCount,
                  (index) => _photoPlaceholder(index),
                ),
                _addPhotoButton(),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              'Videos',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: darkBlue,
              ),
            ),

            const SizedBox(height: 12),

            if (videoAdded)
              _videoAdded()
            else
              _addVideoButton(),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Next: Review Report',
                  style: TextStyle(
                    fontSize: 15,
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

  Widget _addPhotoButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (photoCount < 5) {
            photoCount++;
          }
        });
      },
      child: Container(
        height: 105,
        width: 105,
        decoration: BoxDecoration(
          color: lightBlue,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: primaryBlue.withOpacity(0.2),
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_a_photo_outlined,
              color: primaryBlue,
              size: 30,
            ),
            SizedBox(height: 7),
            Text(
              'Add Photo',
              style: TextStyle(
                color: darkBlue,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _photoPlaceholder(int index) {
    return Container(
      height: 105,
      width: 105,
      decoration: BoxDecoration(
        color: const Color(0xFFE7EEF8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          const Center(
            child: Icon(
              Icons.image_outlined,
              color: primaryBlue,
              size: 35,
            ),
          ),
          Positioned(
            right: 5,
            top: 5,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  photoCount--;
                });
              },
              child: Container(
                height: 25,
                width: 25,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: const Icon(
                  Icons.close,
                  size: 16,
                  color: darkBlue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addVideoButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          videoAdded = true;
        });
      },
      child: Container(
        height: 110,
        width: double.infinity,
        decoration: BoxDecoration(
          color: lightBlue,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: primaryBlue.withOpacity(0.2),
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.videocam_outlined,
              color: primaryBlue,
              size: 34,
            ),
            SizedBox(height: 8),
            Text(
              'Add Video',
              style: TextStyle(
                color: darkBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _videoAdded() {
    return Container(
      height: 110,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFE7EEF8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          const Center(
            child: Icon(
              Icons.play_circle_outline,
              color: primaryBlue,
              size: 48,
            ),
          ),
          Positioned(
            top: 7,
            right: 7,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  videoAdded = false;
                });
              },
              child: const Icon(
                Icons.close,
                color: darkBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _progressBar() {
    return Row(
      children: [
        _step('1', 'Details', true),
        Expanded(
          child: Container(
            height: 2,
            color: primaryBlue,
          ),
        ),
        _step('2', 'Upload', true),
        Expanded(
          child: Container(
            height: 2,
            color: Colors.grey.shade300,
          ),
        ),
        _step('3', 'Review', false),
      ],
    );
  }

  Widget _step(
    String number,
    String title,
    bool active,
  ) {
    return Column(
      children: [
        Container(
          height: 36,
          width: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active
                ? primaryBlue
                : Colors.grey.shade200,
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: active
                    ? Colors.white
                    : Colors.grey.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            color: active ? primaryBlue : Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}