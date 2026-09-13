import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'signup_otp_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with WidgetsBindingObserver {
  // ------------------------------------------------------------
  // Controllers
  // ------------------------------------------------------------

  final TextEditingController firstNameController =
      TextEditingController();

  final TextEditingController lastNameController =
      TextEditingController();

  final TextEditingController phoneController =
      TextEditingController();

  final TextEditingController addressController =
      TextEditingController();

  // ------------------------------------------------------------
  // Image Picker
  // ------------------------------------------------------------

  final ImagePicker _imagePicker = ImagePicker();

  File? _profileImage;

  // ------------------------------------------------------------
  // Permission states
  // ------------------------------------------------------------

  bool locationPermission = false;
  bool smsPermission = false;
  bool notificationPermission = false;

  bool _loadingPermission = false;

  // ------------------------------------------------------------
  // Colors
  // ------------------------------------------------------------

  static const Color primaryBlue = Color(0xFF1769E0);
  static const Color darkBlue = Color(0xFF123B70);
  static const Color background = Color(0xFFF6F8FC);
  static const Color textDark = Color(0xFF172033);
  static const Color textGrey = Color(0xFF6B7280);
  static const Color lightBlue = Color(0xFFEAF2FF);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _checkPermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    addressController.dispose();

    super.dispose();
  }

  // ------------------------------------------------------------
  // Refresh permissions when returning from Android Settings
  // ------------------------------------------------------------

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermissions();
    }
  }

  // ------------------------------------------------------------
  // Check current Android permission status
  // ------------------------------------------------------------

  Future<void> _checkPermissions() async {
    try {
      final locationStatus =
          await Permission.locationWhenInUse.status;

      final smsStatus =
          await Permission.sms.status;

      final notificationStatus =
          await Permission.notification.status;

      if (!mounted) return;

      setState(() {
        locationPermission = locationStatus.isGranted;
        smsPermission = smsStatus.isGranted;
        notificationPermission =
            notificationStatus.isGranted ||
            notificationStatus.isLimited;
      });
    } catch (e) {
      debugPrint("PERMISSION CHECK ERROR: $e");
    }
  }

  // ------------------------------------------------------------
  // Request Location Permission
  // ------------------------------------------------------------

  Future<void> _requestLocationPermission() async {
    if (_loadingPermission) return;

    setState(() {
      _loadingPermission = true;
    });

    try {
      final status =
          await Permission.locationWhenInUse.request();

      if (!mounted) return;

      setState(() {
        locationPermission = status.isGranted;
      });

      if (status.isGranted) {
        _showMessage(
          "Location permission enabled.",
          Colors.green,
        );
      } else if (status.isPermanentlyDenied) {
        _showPermissionSettingsDialog(
          "Location Permission",
          "Location permission is permanently denied. "
          "Please enable it from Android Settings.",
        );
      } else {
        _showMessage(
          "Location permission is required for this app.",
          Colors.red,
        );
      }
    } catch (e) {
      debugPrint("LOCATION PERMISSION ERROR: $e");

      if (mounted) {
        _showMessage(
          "Unable to request location permission.",
          Colors.red,
        );
      }
    }

    if (mounted) {
      setState(() {
        _loadingPermission = false;
      });
    }
  }

  // ------------------------------------------------------------
  // Request SMS Permission
  // ------------------------------------------------------------

  Future<void> _requestSmsPermission() async {
    if (_loadingPermission) return;

    setState(() {
      _loadingPermission = true;
    });

    try {
      final status = await Permission.sms.request();

      if (!mounted) return;

      setState(() {
        smsPermission = status.isGranted;
      });

      if (status.isGranted) {
        _showMessage(
          "SMS permission enabled.",
          Colors.green,
        );
      } else if (status.isPermanentlyDenied) {
        _showPermissionSettingsDialog(
          "SMS Permission",
          "SMS permission is permanently denied. "
          "Please enable it from Android Settings.",
        );
      } else {
        _showMessage(
          "SMS permission is required for signup.",
          Colors.red,
        );
      }
    } catch (e) {
      debugPrint("SMS PERMISSION ERROR: $e");

      if (mounted) {
        _showMessage(
          "Unable to request SMS permission.",
          Colors.red,
        );
      }
    }

    if (mounted) {
      setState(() {
        _loadingPermission = false;
      });
    }
  }

  // ------------------------------------------------------------
  // Request Notification Permission
  // ------------------------------------------------------------

  Future<void> _requestNotificationPermission() async {
    if (_loadingPermission) return;

    setState(() {
      _loadingPermission = true;
    });

    try {
      final status =
          await Permission.notification.request();

      if (!mounted) return;

      setState(() {
        notificationPermission =
            status.isGranted ||
            status.isLimited;
      });

      if (status.isGranted || status.isLimited) {
        _showMessage(
          "Notification permission enabled.",
          Colors.green,
        );
      } else if (status.isPermanentlyDenied) {
        _showPermissionSettingsDialog(
          "Notification Permission",
          "Notification permission is permanently denied. "
          "Please enable notifications from Android Settings.",
        );
      } else {
        _showMessage(
          "Notification permission is required.",
          Colors.red,
        );
      }
    } catch (e) {
      debugPrint("NOTIFICATION PERMISSION ERROR: $e");

      if (mounted) {
        _showMessage(
          "Unable to request notification permission.",
          Colors.red,
        );
      }
    }

    if (mounted) {
      setState(() {
        _loadingPermission = false;
      });
    }
  }

  // ------------------------------------------------------------
  // Open Android Settings
  // ------------------------------------------------------------

  Future<void> _openSettings() async {
    await openAppSettings();
  }

  // ------------------------------------------------------------
  // Permission Settings Dialog
  // ------------------------------------------------------------

  void _showPermissionSettingsDialog(
    String title,
    String message,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await _openSettings();
              },
              child: const Text("Open Settings"),
            ),
          ],
        );
      },
    );
  }

  // ------------------------------------------------------------
  // Gallery Image Picker
  // ------------------------------------------------------------

  Future<void> _pickProfileImage() async {
    try {
      final XFile? pickedImage =
          await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1200,
      );

      if (pickedImage == null) {
        return;
      }

      if (!mounted) return;

      setState(() {
        _profileImage = File(pickedImage.path);
      });

      _showMessage(
        "Profile photo selected.",
        Colors.green,
      );
    } catch (e) {
      debugPrint("PROFILE IMAGE ERROR: $e");

      if (mounted) {
        _showMessage(
          "Unable to select image from gallery.",
          Colors.red,
        );
      }
    }
  }

  // ------------------------------------------------------------
  // Remove Profile Image
  // ------------------------------------------------------------

  void _removeProfileImage() {
    setState(() {
      _profileImage = null;
    });

    _showMessage(
      "Profile photo removed.",
      Colors.grey.shade700,
    );
  }

  // ------------------------------------------------------------
  // Profile Image Options
  // ------------------------------------------------------------

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Profile Photo",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),

                const SizedBox(height: 15),

                ListTile(
                  leading: const Icon(
                    Icons.photo_library_outlined,
                    color: primaryBlue,
                  ),
                  title: const Text("Choose from Gallery"),
                  onTap: () {
                    Navigator.pop(context);
                    _pickProfileImage();
                  },
                ),

                if (_profileImage != null)
                  ListTile(
                    leading: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                    title: const Text("Remove Photo"),
                    onTap: () {
                      Navigator.pop(context);
                      _removeProfileImage();
                    },
                  ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  // ------------------------------------------------------------
  // Validation
  // ------------------------------------------------------------

  bool _validateForm() {
    if (firstNameController.text.trim().isEmpty) {
      _showMessage(
        "Please enter your first name.",
        Colors.red,
      );
      return false;
    }

    if (lastNameController.text.trim().isEmpty) {
      _showMessage(
        "Please enter your last name.",
        Colors.red,
      );
      return false;
    }

    final phone =
        phoneController.text.trim();

    if (phone.isEmpty) {
      _showMessage(
        "Please enter your phone number.",
        Colors.red,
      );
      return false;
    }

    if (!RegExp(r'^[0-9]{10}$').hasMatch(phone)) {
      _showMessage(
        "Enter a valid 10-digit phone number.",
        Colors.red,
      );
      return false;
    }

    if (addressController.text.trim().isEmpty) {
      _showMessage(
        "Please enter your address.",
        Colors.red,
      );
      return false;
    }

    // Photo intentionally NOT checked.
    // It is optional.

    if (!locationPermission) {
      _showMessage(
        "Please enable Location permission.",
        Colors.red,
      );
      return false;
    }

    if (!smsPermission) {
      _showMessage(
        "Please enable SMS permission.",
        Colors.red,
      );
      return false;
    }

    if (!notificationPermission) {
      _showMessage(
        "Please enable Notification permission.",
        Colors.red,
      );
      return false;
    }

    return true;
  }

  // ------------------------------------------------------------
  // Signup
  // ------------------------------------------------------------

  void _signup() {
    FocusScope.of(context).unfocus();

    if (!_validateForm()) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignupOtpScreen(
          phoneNumber: phoneController.text.trim(),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // SnackBar
  // ------------------------------------------------------------

  void _showMessage(
    String message,
    Color color,
  ) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  // ------------------------------------------------------------
  // Permission Tile
  // ------------------------------------------------------------

  Widget _buildPermissionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: enabled
              ? Colors.green.withOpacity(0.35)
              : Colors.grey.shade200,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),

        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: enabled
                ? Colors.green.withOpacity(0.10)
                : lightBlue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: enabled
                ? Colors.green
                : primaryBlue,
          ),
        ),

        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: textDark,
          ),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            enabled
                ? "Permission enabled"
                : subtitle,
            style: TextStyle(
              fontSize: 12,
              color: enabled
                  ? Colors.green
                  : textGrey,
            ),
          ),
        ),

        trailing: Switch(
          value: enabled,
          onChanged: (_) {
            onTap();
          },
          activeColor: Colors.green,
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // Input Field
  // ------------------------------------------------------------

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType =
        TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,

        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(
            icon,
            color: primaryBlue,
          ),

          filled: true,
          fillColor: Colors.white,

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: Colors.grey.shade200,
            ),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: Colors.grey.shade200,
            ),
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
    );
  }

  // ------------------------------------------------------------
  // Build
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      resizeToAvoidBottomInset: true,

      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: darkBlue,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          "Create Account",
          style: TextStyle(
            color: darkBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior.onDrag,

          padding: const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            30,
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              // --------------------------------------------------
              // Header
              // --------------------------------------------------

              const Text(
                "Create your account",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: darkBlue,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "Enter your details to register with Pahad Alert.",
                style: TextStyle(
                  color: textGrey,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 24),

              // --------------------------------------------------
              // Profile Photo
              // --------------------------------------------------

              Center(
                child: GestureDetector(
                  onTap: _showImageOptions,

                  child: Stack(
                    children: [
                      Container(
                        width: 110,
                        height: 110,

                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: lightBlue,

                          image: _profileImage != null
                              ? DecorationImage(
                                  image: FileImage(
                                    _profileImage!,
                                  ),
                                  fit: BoxFit.cover,
                                )
                              : null,

                          border: Border.all(
                            color: Colors.white,
                            width: 4,
                          ),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.08),
                              blurRadius: 15,
                              offset:
                                  const Offset(0, 5),
                            ),
                          ],
                        ),

                        child: _profileImage == null
                            ? const Icon(
                                Icons.person,
                                size: 55,
                                color: primaryBlue,
                              )
                            : null,
                      ),

                      Positioned(
                        right: 0,
                        bottom: 2,

                        child: Container(
                          width: 34,
                          height: 34,

                          decoration:
                              const BoxDecoration(
                            color: primaryBlue,
                            shape: BoxShape.circle,
                          ),

                          child: const Icon(
                            Icons.camera_alt_outlined,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),

              const Center(
                child: Text(
                  "Profile photo (Optional)",
                  style: TextStyle(
                    color: textGrey,
                    fontSize: 12,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // --------------------------------------------------
              // Personal Details
              // --------------------------------------------------

              const Text(
                "Personal Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),

              const SizedBox(height: 14),

              _buildTextField(
                controller: firstNameController,
                label: "First Name *",
                hint: "Enter first name",
                icon: Icons.person_outline,
              ),

              _buildTextField(
                controller: lastNameController,
                label: "Last Name *",
                hint: "Enter last name",
                icon: Icons.person_outline,
              ),

              _buildTextField(
                controller: phoneController,
                label: "Phone Number *",
                hint: "10-digit mobile number",
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),

              _buildTextField(
                controller: addressController,
                label: "Address *",
                hint: "Enter your current address",
                icon: Icons.home_outlined,
                maxLines: 3,
              ),

              const SizedBox(height: 8),

              // --------------------------------------------------
              // Required Permissions
              // --------------------------------------------------

              const Text(
                "Required Permissions",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "These permissions are required for emergency alerts and location-based safety features.",
                style: TextStyle(
                  fontSize: 13,
                  color: textGrey,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 16),

              // Location
              _buildPermissionTile(
                title: "Location",
                subtitle:
                    "Required for your location and nearby safety information.",
                icon: Icons.location_on_outlined,
                enabled: locationPermission,
                onTap: _requestLocationPermission,
              ),

              // SMS
              _buildPermissionTile(
                title: "SMS",
                subtitle:
                    "Required for emergency SMS-related features.",
                icon: Icons.sms_outlined,
                enabled: smsPermission,
                onTap: _requestSmsPermission,
              ),

              // Notifications
              _buildPermissionTile(
                title: "Notifications",
                subtitle:
                    "Required to receive landslide and emergency alerts.",
                icon: Icons.notifications_outlined,
                enabled: notificationPermission,
                onTap: _requestNotificationPermission,
              ),

              const SizedBox(height: 12),

              // --------------------------------------------------
              // Permission Status
              // --------------------------------------------------

              if (locationPermission &&
                  smsPermission &&
                  notificationPermission)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),

                  decoration: BoxDecoration(
                    color: Colors.green
                        .withOpacity(0.08),
                    borderRadius:
                        BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.green
                          .withOpacity(0.25),
                    ),
                  ),

                  child: const Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "All required permissions are enabled.",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 24),

              // --------------------------------------------------
              // Signup Button
              // --------------------------------------------------

              SizedBox(
                width: double.infinity,
                height: 56,

                child: ElevatedButton(
                  onPressed: _signup,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,

                    elevation: 0,

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(16),
                    ),
                  ),

                  child: const Text(
                    "Continue to OTP",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              const Center(
                child: Text(
                  "* All fields and required permissions are compulsory. Profile photo is optional.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: textGrey,
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