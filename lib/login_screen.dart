import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'login_otp_screen.dart';
import 'signup_screen.dart';
import 'terms_of_service_screen.dart';
import 'privacy_policy_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color primaryBlue = Color(0xFF1769E0);
  static const Color darkBlue = Color(0xFF123B70);
  static const Color background = Color(0xFFF7F9FC);
  static const Color textDark = Color(0xFF172033);
  static const Color textGrey = Color(0xFF667085);
  static const Color borderColor = Color(0xFFD9E1EC);
  static const Color errorColor = Color(0xFFD92D20);

  // ============================================================
  // CONTROLLERS
  // ============================================================

  final TextEditingController phoneController =
      TextEditingController();

  final FocusNode phoneFocusNode = FocusNode();

  // ============================================================
  // VARIABLES
  // ============================================================

  bool isSendingOtp = false;
  bool showError = false;

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    phoneController.dispose();
    phoneFocusNode.dispose();
    super.dispose();
  }

  // ============================================================
  // VALIDATE PHONE
  // ============================================================

  bool isValidPhone() {
    final phone = phoneController.text.trim();

    return RegExp(r'^[0-9]{10}$').hasMatch(phone);
  }

  // ============================================================
  // SEND OTP
  // ============================================================

  Future<void> sendOtp() async {
    FocusScope.of(context).unfocus();

    if (!isValidPhone()) {
      setState(() {
        showError = true;
      });
      return;
    }

    setState(() {
      isSendingOtp = true;
      showError = false;
    });

    // Temporary delay.
    // Later replace this with Firebase/API OTP service.
    await Future.delayed(
      const Duration(milliseconds: 700),
    );

    if (!mounted) return;

    setState(() {
      isSendingOtp = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginOtpScreen(
          phoneNumber: phoneController.text.trim(),
        ),
      ),
    );
  }

  // ============================================================
  // LOGO
  // ============================================================

  Widget buildLogo() {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: primaryBlue.withOpacity(0.14),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: primaryBlue.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Container(
            margin: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: primaryBlue,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: Colors.white,
              size: 34,
            ),
          ),
        ),

        const SizedBox(height: 11),

        const Text(
          'PahadAlert',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
            color: darkBlue,
            letterSpacing: -0.5,
          ),
        ),

        const SizedBox(height: 4),

        const Text(
          'Landslide Safety & Early Warning',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11.5,
            color: textGrey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PHONE FIELD
  // ============================================================

  Widget buildPhoneField() {
    return TextField(
      controller: phoneController,
      focusNode: phoneFocusNode,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      maxLength: 10,

      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: textDark,
        letterSpacing: 0.2,
      ),

      decoration: InputDecoration(
        counterText: '',

        hintText: 'Enter your mobile number',

        hintStyle: const TextStyle(
          fontSize: 13.5,
          color: Color(0xFF98A2B3),
          fontWeight: FontWeight.w400,
        ),

        prefixIcon: const Padding(
          padding: EdgeInsets.only(
            left: 14,
            right: 8,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.phone_outlined,
                size: 20,
                color: primaryBlue,
              ),
              SizedBox(width: 7),
              Text(
                '+91',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: textDark,
                ),
              ),
              SizedBox(width: 8),
              SizedBox(
                height: 22,
                child: VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: borderColor,
                ),
              ),
              SizedBox(width: 7),
            ],
          ),
        ),

        filled: true,
        fillColor: Colors.white,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 16,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: showError
                ? errorColor
                : borderColor,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: showError
                ? errorColor
                : primaryBlue,
            width: 1.6,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: errorColor,
          ),
        ),
      ),

      onChanged: (value) {
        if (showError) {
          setState(() {
            showError = false;
          });
        }
      },

      onSubmitted: (_) {
        sendOtp();
      },
    );
  }

  // ============================================================
  // ERROR MESSAGE
  // ============================================================

  Widget buildErrorMessage() {
    if (!showError) {
      return const SizedBox.shrink();
    }

    return const Padding(
      padding: EdgeInsets.only(
        top: 7,
        left: 3,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 15,
            color: errorColor,
          ),
          SizedBox(width: 5),
          Expanded(
            child: Text(
              'Please enter a valid 10-digit mobile number.',
              style: TextStyle(
                fontSize: 11.5,
                color: errorColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SEND OTP BUTTON
  // ============================================================

  Widget buildSendOtpButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isSendingOtp
            ? null
            : sendOtp,

        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          disabledBackgroundColor:
              primaryBlue.withOpacity(0.55),
          foregroundColor: Colors.white,
          elevation: 0,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        child: isSendingOtp
            ? const SizedBox(
                width: 21,
                height: 21,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(
                    Colors.white,
                  ),
                ),
              )
            : const Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Text(
                    'Send OTP',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 18,
                  ),
                ],
              ),
      ),
    );
  }

  // ============================================================
  // SECURITY INFO
  // ============================================================

  Widget buildSecurityInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F6FF),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: const Color(0xFFDCEAFF),
        ),
      ),
      child: const Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.verified_user_outlined,
            color: primaryBlue,
            size: 19,
          ),
          SizedBox(width: 9),
          Expanded(
            child: Text(
              'Your mobile number is used for secure '
              'OTP-based authentication.',
              style: TextStyle(
                fontSize: 11.2,
                height: 1.4,
                color: Color(0xFF475467),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TERMS + PRIVACY
  // ============================================================

  Widget buildLegalText() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      child: Text.rich(
        TextSpan(
          text: 'By continuing, you agree to our ',
          style: const TextStyle(
            fontSize: 11.2,
            height: 1.45,
            color: textGrey,
          ),
          children: [
            TextSpan(
              text: 'Terms of Service',
              style: const TextStyle(
                color: primaryBlue,
                fontWeight: FontWeight.w700,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const TermsOfServiceScreen(),
                    ),
                  );
                },
            ),

            const TextSpan(
              text: ' and ',
            ),

            TextSpan(
              text: 'Privacy Policy',
              style: const TextStyle(
                color: primaryBlue,
                fontWeight: FontWeight.w700,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const PrivacyPolicyScreen(),
                    ),
                  );
                },
            ),

            const TextSpan(
              text: '.',
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // ============================================================
  // SIGN UP
  // ============================================================

  Widget buildSignUpSection() {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          const Text(
            "Don't have an account? ",
            style: TextStyle(
              fontSize: 12.5,
              color: textGrey,
            ),
          ),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const SignUpScreen(),
                ),
              );
            },
            child: const Text(
              'Sign Up',
              style: TextStyle(
                fontSize: 12.5,
                color: primaryBlue,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final double keyboardHeight =
        MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: background,

      resizeToAvoidBottomInset: true,

      body: SafeArea(
        child: LayoutBuilder(
          builder: (
            BuildContext context,
            BoxConstraints constraints,
          ) {
            return SingleChildScrollView(
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior
                      .onDrag,

              physics:
                  const BouncingScrollPhysics(),

              padding: EdgeInsets.fromLTRB(
                22,
                28,
                22,
                keyboardHeight + 25,
              ),

              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      constraints.maxHeight - 53,
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    // ==================================================
                    // LOGO
                    // ==================================================

                    Center(
                      child: buildLogo(),
                    ),

                    const SizedBox(height: 42),

                    // ==================================================
                    // TITLE
                    // ==================================================

                    const Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                        color: textDark,
                        letterSpacing: -0.5,
                      ),
                    ),

                    const SizedBox(height: 7),

                    const Text(
                      'Sign in to continue to PahadAlert',
                      style: TextStyle(
                        fontSize: 13,
                        color: textGrey,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 26),

                    // ==================================================
                    // PHONE LABEL
                    // ==================================================

                    const Text(
                      'Mobile Number',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: textDark,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // ==================================================
                    // PHONE FIELD
                    // ==================================================

                    buildPhoneField(),

                    // ==================================================
                    // ERROR
                    // ==================================================

                    buildErrorMessage(),

                    const SizedBox(height: 18),

                    // ==================================================
                    // SEND OTP
                    // ==================================================

                    buildSendOtpButton(),

                    const SizedBox(height: 22),

                    // ==================================================
                    // SECURITY
                    // ==================================================

                    buildSecurityInfo(),

                    const SizedBox(height: 22),

                    // ==================================================
                    // LEGAL
                    // ==================================================

                    buildLegalText(),

                    const SizedBox(height: 22),

                    // ==================================================
                    // SIGN UP
                    // ==================================================

                    buildSignUpSection(),

                    const SizedBox(height: 22),

                    // ==================================================
                    // FOOTER
                    // ==================================================

                    Center(
                      child: Text(
                        'PahadAlert • Citizen Safety Platform',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}