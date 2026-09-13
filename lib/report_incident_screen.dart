import 'package:flutter/material.dart';
import 'upload_incident_screen.dart';

class ReportIncidentScreen extends StatefulWidget {
  const ReportIncidentScreen({super.key});

  @override
  State<ReportIncidentScreen> createState() =>
      _ReportIncidentScreenState();
}

class _ReportIncidentScreenState
    extends State<ReportIncidentScreen> {
  static const Color primaryBlue = Color(0xFF1769E0);
  static const Color darkBlue = Color(0xFF123B70);
  static const Color lightBlue = Color(0xFFF4F8FF);

  String incidentType = 'Road Blockage';
  String severity = 'High';

  final descriptionController = TextEditingController();

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  void nextPage() {
    if (descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a description.'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UploadIncidentScreen(
          incidentType: incidentType,
          severity: severity,
          description: descriptionController.text.trim(),
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
          'Report Incident',
          style: TextStyle(
            color: darkBlue,
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _progressBar(),

            const SizedBox(height: 28),

            const Text(
              'Incident Details',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: darkBlue,
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              'Incident Type',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: darkBlue,
              ),
            ),

            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: lightBlue,
                borderRadius: BorderRadius.circular(14),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: incidentType,
                  isExpanded: true,
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: primaryBlue,
                  ),
                  style: const TextStyle(
                    color: darkBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Road Blockage',
                      child: Text('Road Blockage'),
                    ),
                    DropdownMenuItem(
                      value: 'Landslide',
                      child: Text('Landslide'),
                    ),
                    DropdownMenuItem(
                      value: 'Flood',
                      child: Text('Flood'),
                    ),
                    DropdownMenuItem(
                      value: 'Rockfall',
                      child: Text('Rockfall'),
                    ),
                    DropdownMenuItem(
                      value: 'Road Damage',
                      child: Text('Road Damage'),
                    ),
                    DropdownMenuItem(
                      value: 'Other Disaster',
                      child: Text('Other Disaster'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      incidentType = value!;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              'Description',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: darkBlue,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText:
                    'Describe the incident or disaster...',
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
                filled: true,
                fillColor: lightBlue,
                contentPadding: const EdgeInsets.all(15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: primaryBlue,
                    width: 1.5,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              'Severity',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: darkBlue,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                _severityButton('Low'),
                const SizedBox(width: 7),
                _severityButton('Moderate'),
                const SizedBox(width: 7),
                _severityButton('High'),
                const SizedBox(width: 7),
                _severityButton('Very High'),
              ],
            ),

            const SizedBox(height: 22),

            const Text(
              'Date & Time',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: darkBlue,
              ),
            ),

            const SizedBox(height: 8),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 17,
              ),
              decoration: BoxDecoration(
                color: lightBlue,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                children: [
                  Expanded(
                    child: Text(
                      '13 September 2026, 08:15 AM',
                      style: TextStyle(
                        color: darkBlue,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.calendar_month_outlined,
                    color: primaryBlue,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

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
                  'Next: Upload',
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

  Widget _severityButton(String value) {
    final selected = severity == value;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            severity = value;
          });
        },
        child: Container(
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? primaryBlue : lightBlue,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: selected ? Colors.white : darkBlue,
            ),
          ),
        ),
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
            color: Colors.grey.shade300,
          ),
        ),
        _step('2', 'Upload', false),
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