import 'package:flutter/material.dart';
import 'upload_incident_screen.dart';

class ReportIncidentScreen extends StatefulWidget {
  const ReportIncidentScreen({super.key});

  @override
  State<ReportIncidentScreen> createState() =>
      _ReportIncidentScreenState();
}

class _ReportIncidentScreenState extends State<ReportIncidentScreen> {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color primaryBlue = Color(0xFF1769E0);
  static const Color darkBlue = Color(0xFF123B70);
  static const Color background = Color(0xFFF7F9FC);
  static const Color softBlue = Color(0xFFEAF2FF);
  static const Color textDark = Color(0xFF172033);
  static const Color textGrey = Color(0xFF697386);

  // ============================================================
  // DATA
  // ============================================================

  String incidentType = 'Landslide';
  String severity = 'High';

  final TextEditingController descriptionController =
      TextEditingController();

  final FocusNode descriptionFocusNode = FocusNode();

  DateTime selectedDateTime = DateTime.now();

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    descriptionController.dispose();
    descriptionFocusNode.dispose();
    super.dispose();
  }

  // ============================================================
  // CLOSE KEYBOARD
  // ============================================================

  void _closeKeyboard() {
    descriptionFocusNode.unfocus();
    FocusScope.of(context).unfocus();
  }

  // ============================================================
  // FORMAT DATE
  // ============================================================

  String _formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  // ============================================================
  // FORMAT TIME
  // ============================================================

  String _formatTime(DateTime date) {
    int hour = date.hour;

    final minute = date.minute.toString().padLeft(2, '0');

    final period = hour >= 12 ? 'PM' : 'AM';

    hour = hour % 12;

    if (hour == 0) {
      hour = 12;
    }

    return '$hour:$minute $period';
  }

  // ============================================================
  // PICK DATE
  // ============================================================

  Future<void> _pickDate() async {
    // Remove description focus first.
    _closeKeyboard();

    // Give Android keyboard time to close.
    await Future.delayed(
      const Duration(milliseconds: 200),
    );

    if (!mounted) return;

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryBlue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: textDark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (!mounted) return;

    if (pickedDate != null) {
      setState(() {
        selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          selectedDateTime.hour,
          selectedDateTime.minute,
        );
      });
    }

    // IMPORTANT:
    // Do not allow description to regain focus.
    _closeKeyboard();
  }

  // ============================================================
  // PICK TIME
  // ============================================================

  Future<void> _pickTime() async {
    // Remove description focus first.
    _closeKeyboard();

    // Give Android keyboard time to close.
    await Future.delayed(
      const Duration(milliseconds: 200),
    );

    if (!mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        selectedDateTime,
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryBlue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: textDark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (!mounted) return;

    if (pickedTime != null) {
      setState(() {
        selectedDateTime = DateTime(
          selectedDateTime.year,
          selectedDateTime.month,
          selectedDateTime.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
    }

    // IMPORTANT:
    // Do not allow description to regain focus.
    _closeKeyboard();
  }

  // ============================================================
  // NEXT PAGE
  // ============================================================

  void nextPage() {
    // Close keyboard before navigation.
    _closeKeyboard();

    final description =
        descriptionController.text.trim();

    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: darkBlue,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: const Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Please describe what you observed.',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
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
          description: description,
        ),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,

      onTap: () {
        // Tapping outside the description closes keyboard.
        _closeKeyboard();
      },

      child: Scaffold(
        backgroundColor: background,

        resizeToAvoidBottomInset: true,

        appBar: AppBar(
          backgroundColor: background,
          elevation: 0,
          surfaceTintColor: Colors.transparent,

          leading: IconButton(
            onPressed: () {
              _closeKeyboard();
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: darkBlue,
              size: 19,
            ),
          ),

          title: const Text(
            'Report Incident',
            style: TextStyle(
              color: darkBlue,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),

          centerTitle: true,
        ),

        body: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,

            physics: const BouncingScrollPhysics(),

            padding: const EdgeInsets.fromLTRB(
              18,
              8,
              18,
              30,
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                _buildProgress(),

                const SizedBox(height: 30),

                const Text(
                  'Tell us what happened',
                  style: TextStyle(
                    color: textDark,
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.7,
                  ),
                ),

                const SizedBox(height: 7),

                const Text(
                  'Provide a few details about the incident you observed.',
                  style: TextStyle(
                    color: textGrey,
                    fontSize: 13,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 28),

                _buildSectionTitle(
                  'What happened?',
                  'Select the type of incident',
                ),

                const SizedBox(height: 14),

                _buildIncidentTypes(),

                const SizedBox(height: 28),

                _buildSectionTitle(
                  'Describe the incident',
                  'Tell us what you saw',
                ),

                const SizedBox(height: 14),

                _buildDescriptionBox(),

                const SizedBox(height: 28),

                _buildSectionTitle(
                  'How serious is it?',
                  'Choose the current severity',
                ),

                const SizedBox(height: 14),

                _buildSeverity(),

                const SizedBox(height: 28),

                _buildSectionTitle(
                  'When did it happen?',
                  'Select the date and time',
                ),

                const SizedBox(height: 14),

                _buildDateTime(),

                const SizedBox(height: 32),

                _buildNextButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _buildSectionTitle(
    String title,
    String subtitle,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: textDark,
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          subtitle,
          style: const TextStyle(
            color: textGrey,
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PROGRESS
  // ============================================================

  Widget _buildProgress() {
    return Row(
      children: [
        _buildProgressStep(
          number: '1',
          title: 'Details',
          active: true,
        ),

        Expanded(
          child: Container(
            height: 2,
            margin: const EdgeInsets.only(
              bottom: 18,
            ),
            color: primaryBlue,
          ),
        ),

        _buildProgressStep(
          number: '2',
          title: 'Upload',
          active: false,
        ),

        Expanded(
          child: Container(
            height: 2,
            margin: const EdgeInsets.only(
              bottom: 18,
            ),
            color: Colors.grey.shade300,
          ),
        ),

        _buildProgressStep(
          number: '3',
          title: 'Review',
          active: false,
        ),
      ],
    );
  }

  Widget _buildProgressStep({
    required String number,
    required String title,
    required bool active,
  }) {
    return Column(
      children: [
        AnimatedContainer(
          duration:
              const Duration(milliseconds: 200),

          width: 36,
          height: 36,

          decoration: BoxDecoration(
            color: active
                ? primaryBlue
                : Colors.white,

            shape: BoxShape.circle,

            border: Border.all(
              color: active
                  ? primaryBlue
                  : Colors.grey.shade300,
              width: 1.5,
            ),

            boxShadow: active
                ? [
                    BoxShadow(
                      color: primaryBlue
                          .withOpacity(0.20),
                      blurRadius: 10,
                      offset:
                          const Offset(0, 4),
                    ),
                  ]
                : null,
          ),

          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: active
                    ? Colors.white
                    : textGrey,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),

        const SizedBox(height: 5),

        Text(
          title,
          style: TextStyle(
            color: active
                ? primaryBlue
                : textGrey,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // INCIDENT TYPES
  // ============================================================

  Widget _buildIncidentTypes() {
    final types = [
      {
        'title': 'Landslide',
        'icon': Icons.terrain_rounded,
      },
      {
        'title': 'Road Blockage',
        'icon': Icons.block_rounded,
      },
      {
        'title': 'Rockfall',
        'icon': Icons.landscape_rounded,
      },
      {
        'title': 'Flood',
        'icon': Icons.water_rounded,
      },
      {
        'title': 'Road Damage',
        'icon': Icons.construction_rounded,
      },
      {
        'title': 'Other Disaster',
        'icon': Icons.warning_amber_rounded,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(),

      itemCount: types.length,

      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2.7,
      ),

      itemBuilder: (context, index) {
        final item = types[index];

        final title =
            item['title'] as String;

        final icon =
            item['icon'] as IconData;

        final selected =
            incidentType == title;

        return GestureDetector(
          onTap: () {
            _closeKeyboard();

            setState(() {
              incidentType = title;
            });
          },

          child: AnimatedContainer(
            duration:
                const Duration(milliseconds: 180),

            padding:
                const EdgeInsets.symmetric(
              horizontal: 12,
            ),

            decoration: BoxDecoration(
              color: selected
                  ? softBlue
                  : Colors.white,

              borderRadius:
                  BorderRadius.circular(15),

              border: Border.all(
                color: selected
                    ? primaryBlue
                    : Colors.grey.shade200,
                width: selected ? 1.5 : 1,
              ),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(
                    selected ? 0.04 : 0.025,
                  ),
                  blurRadius: 8,
                  offset:
                      const Offset(0, 3),
                ),
              ],
            ),

            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,

                  decoration:
                      BoxDecoration(
                    color: selected
                        ? primaryBlue
                        : const Color(
                            0xFFF1F4F8,
                          ),
                    borderRadius:
                        BorderRadius.circular(
                      10,
                    ),
                  ),

                  child: Icon(
                    icon,
                    size: 18,
                    color: selected
                        ? Colors.white
                        : darkBlue,
                  ),
                ),

                const SizedBox(width: 9),

                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: TextStyle(
                      color: selected
                          ? primaryBlue
                          : textDark,
                      fontSize: 11.5,
                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),
                ),

                if (selected)
                  const Icon(
                    Icons
                        .check_circle_rounded,
                    color: primaryBlue,
                    size: 17,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // DESCRIPTION
  // ============================================================

  Widget _buildDescriptionBox() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(17),

        border: Border.all(
          color: Colors.grey.shade200,
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.025),
            blurRadius: 10,
            offset:
                const Offset(0, 4),
          ),
        ],
      ),

      child: TextField(
        controller:
            descriptionController,

        focusNode:
            descriptionFocusNode,

        keyboardType:
            TextInputType.multiline,

        textInputAction:
            TextInputAction.newline,

        maxLines: 5,
        minLines: 5,
        maxLength: 300,

        style: const TextStyle(
          color: textDark,
          fontSize: 13,
          height: 1.45,
          fontWeight: FontWeight.w500,
        ),

        decoration:
            const InputDecoration(
          hintText:
              'Example: Mud and large rocks are blocking the road near the village...',

          hintStyle:
              TextStyle(
            color:
                Color(0xFF9AA3B2),
            fontSize: 12.5,
            height: 1.45,
            fontWeight:
                FontWeight.w500,
          ),

          border:
              InputBorder.none,

          contentPadding:
              EdgeInsets.fromLTRB(
            16,
            16,
            16,
            0,
          ),

          counterStyle:
              TextStyle(
            color: textGrey,
            fontSize: 10,
            fontWeight:
                FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SEVERITY
  // ============================================================

  Widget _buildSeverity() {
    final levels = [
      {
        'title': 'Low',
        'subtitle': 'Minor',
        'icon':
            Icons.check_circle_outline_rounded,
      },
      {
        'title': 'Moderate',
        'subtitle': 'Caution',
        'icon':
            Icons.info_outline_rounded,
      },
      {
        'title': 'High',
        'subtitle': 'Serious',
        'icon':
            Icons.warning_amber_rounded,
      },
      {
        'title': 'Very High',
        'subtitle': 'Danger',
        'icon':
            Icons.dangerous_outlined,
      },
    ];

    return LayoutBuilder(
      builder:
          (context, constraints) {
        final width =
            (constraints.maxWidth - 10) / 2;

        return Wrap(
          spacing: 10,
          runSpacing: 10,

          children:
              levels.map((item) {
            final title =
                item['title'] as String;

            final subtitle =
                item['subtitle']
                    as String;

            final icon =
                item['icon'] as IconData;

            final selected =
                severity == title;

            return GestureDetector(
              onTap: () {
                _closeKeyboard();

                setState(() {
                  severity = title;
                });
              },

              child: AnimatedContainer(
                duration:
                    const Duration(
                  milliseconds: 180,
                ),

                width: width,
                height: 58,

                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 12,
                ),

                decoration:
                    BoxDecoration(
                  color: selected
                      ? primaryBlue
                      : Colors.white,

                  borderRadius:
                      BorderRadius.circular(
                    15,
                  ),

                  border:
                      Border.all(
                    color: selected
                        ? primaryBlue
                        : Colors.grey.shade200,
                    width: selected
                        ? 1.5
                        : 1,
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(
                        0.025,
                      ),
                      blurRadius: 8,
                      offset:
                          const Offset(0, 3),
                    ),
                  ],
                ),

                child: Row(
                  children: [
                    Icon(
                      icon,
                      size: 21,
                      color: selected
                          ? Colors.white
                          : darkBlue,
                    ),

                    const SizedBox(
                      width: 9,
                    ),

                    Expanded(
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .center,

                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow:
                                TextOverflow
                                    .ellipsis,

                            style: TextStyle(
                              color: selected
                                  ? Colors.white
                                  : textDark,
                              fontSize: 12,
                              fontWeight:
                                  FontWeight
                                      .w800,
                            ),
                          ),

                          const SizedBox(
                            height: 2,
                          ),

                          Text(
                            subtitle,
                            style: TextStyle(
                              color: selected
                                  ? Colors.white70
                                  : textGrey,
                              fontSize: 9.5,
                              fontWeight:
                                  FontWeight
                                      .w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (selected)
                      const Icon(
                        Icons.check_rounded,
                        color:
                            Colors.white,
                        size: 18,
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  // ============================================================
  // DATE & TIME
  // ============================================================

  Widget _buildDateTime() {
    return Container(
      padding:
          const EdgeInsets.all(14),

      decoration:
          BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(17),

        border: Border.all(
          color: Colors.grey.shade200,
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(
              0.025,
            ),
            blurRadius: 10,
            offset:
                const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        children: [
          // ======================================================
          // DATE
          // ======================================================

          Expanded(
            child: GestureDetector(
              behavior:
                  HitTestBehavior.opaque,

              onTap: _pickDate,

              child: Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 9,
                ),

                decoration:
                    BoxDecoration(
                  color: background,
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),

                child: Row(
                  children: [
                    Container(
                      width: 35,
                      height: 35,

                      decoration:
                          BoxDecoration(
                        color: softBlue,
                        borderRadius:
                            BorderRadius
                                .circular(
                          10,
                        ),
                      ),

                      child:
                          const Icon(
                        Icons
                            .calendar_today_rounded,
                        color:
                            primaryBlue,
                        size: 17,
                      ),
                    ),

                    const SizedBox(
                      width: 9,
                    ),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [
                          const Text(
                            'DATE',
                            style:
                                TextStyle(
                              color:
                                  textGrey,
                              fontSize:
                                  8,
                              fontWeight:
                                  FontWeight
                                      .w800,
                              letterSpacing:
                                  0.6,
                            ),
                          ),

                          const SizedBox(
                            height: 3,
                          ),

                          Text(
                            _formatDate(
                              selectedDateTime,
                            ),
                            maxLines: 1,
                            overflow:
                                TextOverflow
                                    .ellipsis,

                            style:
                                const TextStyle(
                              color:
                                  textDark,
                              fontSize:
                                  10.5,
                              fontWeight:
                                  FontWeight
                                      .w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(
            width: 10,
          ),

          // ======================================================
          // TIME
          // ======================================================

          Expanded(
            child: GestureDetector(
              behavior:
                  HitTestBehavior.opaque,

              onTap: _pickTime,

              child: Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 9,
                ),

                decoration:
                    BoxDecoration(
                  color: background,
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),

                child: Row(
                  children: [
                    Container(
                      width: 35,
                      height: 35,

                      decoration:
                          BoxDecoration(
                        color: softBlue,
                        borderRadius:
                            BorderRadius
                                .circular(
                          10,
                        ),
                      ),

                      child:
                          const Icon(
                        Icons
                            .access_time_rounded,
                        color:
                            primaryBlue,
                        size: 18,
                      ),
                    ),

                    const SizedBox(
                      width: 9,
                    ),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [
                          const Text(
                            'TIME',
                            style:
                                TextStyle(
                              color:
                                  textGrey,
                              fontSize:
                                  8,
                              fontWeight:
                                  FontWeight
                                      .w800,
                              letterSpacing:
                                  0.6,
                            ),
                          ),

                          const SizedBox(
                            height: 3,
                          ),

                          Text(
                            _formatTime(
                              selectedDateTime,
                            ),
                            maxLines: 1,
                            overflow:
                                TextOverflow
                                    .ellipsis,

                            style:
                                const TextStyle(
                              color:
                                  textDark,
                              fontSize:
                                  10.5,
                              fontWeight:
                                  FontWeight
                                      .w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // NEXT BUTTON
  // ============================================================

  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,

      child: ElevatedButton(
        onPressed: nextPage,

        style:
            ElevatedButton.styleFrom(
          backgroundColor:
              primaryBlue,

          foregroundColor:
              Colors.white,

          elevation: 0,

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              16,
            ),
          ),
        ),

        child: const Row(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            Text(
              'Continue to Upload',
              style: TextStyle(
                fontSize: 14,
                fontWeight:
                    FontWeight.w800,
                letterSpacing: -0.1,
              ),
            ),

            SizedBox(width: 10),

            Icon(
              Icons
                  .arrow_forward_rounded,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}