import 'dart:async';
import 'package:flutter/material.dart';
import 'homescreen.dart';

class LoginOtpScreen extends StatefulWidget {
  final String phoneNumber;

  const LoginOtpScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<LoginOtpScreen> createState() => _LoginOtpScreenState();
}

class _LoginOtpScreenState extends State<LoginOtpScreen> {
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
  // CONTROLLER
  // ============================================================

  final TextEditingController otpController =
      TextEditingController();

  final FocusNode otpFocusNode = FocusNode();

  // ============================================================
  // VARIABLES
  // ============================================================

  Timer? timer;

  int secondsRemaining = 30;

  bool isVerifying = false;

  bool showError = false;

  static const String dummyOtp = '123456';

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    startTimer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        otpFocusNode.requestFocus();
      }
    });
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    timer?.cancel();
    otpController.dispose();
    otpFocusNode.dispose();
    super.dispose();
  }

  // ============================================================
  // TIMER
  // ============================================================

  void startTimer() {
    timer?.cancel();

    setState(() {
      secondsRemaining = 30;
    });

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        if (secondsRemaining > 0) {
          setState(() {
            secondsRemaining--;
          });
        } else {
          timer.cancel();
        }
      },
    );
  }

  // ============================================================
  // PHONE FORMAT
  // ============================================================

  String get formattedPhoneNumber {
    String phone = widget.phoneNumber.trim();

    if (phone.startsWith('+91')) {
      phone = phone.substring(3).trim();
    }

    if (phone.length == 10) {
      return '+91 ${phone.substring(0, 5)} ${phone.substring(5)}';
    }

    return '+91 $phone';
  }

  // ============================================================
  // VERIFY OTP
  // ============================================================

  Future<void> verifyOtp() async {
    FocusScope.of(context).unfocus();

    final String otp = otpController.text.trim();

    if (otp.length != 6) {
      setState(() {
        showError = true;
      });
      return;
    }

    setState(() {
      isVerifying = true;
      showError = false;
    });

    // Temporary dummy verification delay.
    // Replace this later with real backend/API verification.
    await Future.delayed(
      const Duration(milliseconds: 700),
    );

    if (!mounted) return;

    if (otp == dummyOtp) {
      setState(() {
        isVerifying = false;
      });

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
        (route) => false,
      );
    } else {
      setState(() {
        isVerifying = false;
        showError = true;
      });

      otpController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Invalid OTP. Please try again.',
          ),
          backgroundColor: errorColor,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      // Put cursor back in OTP field.
      Future.delayed(
        const Duration(milliseconds: 100),
        () {
          if (mounted) {
            otpFocusNode.requestFocus();
          }
        },
      );
    }
  }

  // ============================================================
  // RESEND OTP
  // ============================================================

  void resendOtp() {
    if (secondsRemaining > 0) {
      return;
    }

    otpController.clear();

    setState(() {
      showError = false;
    });

    startTimer();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'A new OTP has been sent to your mobile number.',
        ),
        backgroundColor: primaryBlue,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        if (mounted) {
          otpFocusNode.requestFocus();
        }
      },
    );
  }

  // ============================================================
  // LOGO
  // ============================================================

  Widget buildLogo() {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: primaryBlue.withOpacity(0.15),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: primaryBlue.withOpacity(0.08),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryBlue,
              borderRadius: BorderRadius.circular(17),
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),

        const SizedBox(height: 10),

        const Text(
          'PahadAlert',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: darkBlue,
            letterSpacing: -0.4,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // OTP TEXT FIELD
  // ============================================================

  Widget buildOtpField() {
    return TextField(
      controller: otpController,
      focusNode: otpFocusNode,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      maxLength: 6,
      textAlign: TextAlign.center,
      autofocus: true,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: 12,
        color: textDark,
      ),
      decoration: InputDecoration(
        counterText: '',
        hintText: '------',
        hintStyle: const TextStyle(
          color: Color(0xFFB8C1CE),
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: 9,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 17,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide(
            color: showError
                ? errorColor
                : borderColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide(
            color: showError
                ? errorColor
                : primaryBlue,
            width: 1.7,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
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

        // Automatically verify when 6 digits are entered.
        if (value.length == 6) {
          verifyOtp();
        }
      },
      onSubmitted: (_) {
        verifyOtp();
      },
    );
  }

  // ============================================================
  // VERIFY BUTTON
  // ============================================================

  Widget buildVerifyButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isVerifying
            ? null
            : verifyOtp,
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
        child: isVerifying
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
                    'Verify & Continue',
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
  // RESEND
  // ============================================================

  Widget buildResendSection() {
    return Column(
      children: [
        const Text(
          'Didn’t receive the code?',
          style: TextStyle(
            fontSize: 12.5,
            color: textGrey,
          ),
        ),

        const SizedBox(height: 7),

        GestureDetector(
          onTap: secondsRemaining == 0
              ? resendOtp
              : null,
          child: Text(
            'Resend OTP',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: secondsRemaining == 0
                  ? primaryBlue
                  : const Color(0xFF98A2B3),
            ),
          ),
        ),

        const SizedBox(height: 6),

        if (secondsRemaining > 0)
          Text(
            'You can resend in 00:${secondsRemaining.toString().padLeft(2, '0')}',
            style: const TextStyle(
              fontSize: 11,
              color: textGrey,
            ),
          ),
      ],
    );
  }

  // ============================================================
  // SECURITY INFORMATION
  // ============================================================

  Widget buildSecurityCard() {
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
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.security_outlined,
              color: primaryBlue,
              size: 17,
            ),
          ),

          const SizedBox(width: 9),

          const Expanded(
            child: Text(
              'Never share your OTP with anyone. '
              'PahadAlert will never ask you for your verification code.',
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
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final double keyboardHeight =
        MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: background,

      // Important for keyboard
      resizeToAvoidBottomInset: true,

      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        scrolledUnderElevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: textDark,
            size: 23,
          ),
        ),
      ),

      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (
            BuildContext context,
            BoxConstraints constraints,
          ) {
            return SingleChildScrollView(
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
              physics:
                  const BouncingScrollPhysics(),

              padding: EdgeInsets.fromLTRB(
                22,
                8,
                22,
                keyboardHeight + 25,
              ),

              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      constraints.maxHeight - 8,
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

                    const SizedBox(height: 32),

                    // ==================================================
                    // TITLE
                    // ==================================================

                    const Text(
                      'Verify Your Mobile Number',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: textDark,
                        letterSpacing: -0.35,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Enter the 6-digit verification code '
                      'sent to your mobile number.',
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.45,
                        color: textGrey,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Row(
                      children: [
                        const Icon(
                          Icons.phone_outlined,
                          size: 15,
                          color: primaryBlue,
                        ),

                        const SizedBox(width: 5),

                        Flexible(
                          child: Text(
                            formattedPhoneNumber,
                            overflow:
                                TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight:
                                  FontWeight.w700,
                              color: darkBlue,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 26),

                    // ==================================================
                    // OTP
                    // ==================================================

                    const Text(
                      'Verification Code',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: textDark,
                      ),
                    ),

                    const SizedBox(height: 8),

                    buildOtpField(),

                    if (showError) ...[
                      const SizedBox(height: 7),

                      const Row(
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            size: 15,
                            color: errorColor,
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              'Please enter a valid 6-digit OTP.',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: errorColor,
                                fontWeight:
                                    FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 20),

                    // ==================================================
                    // VERIFY
                    // ==================================================

                    buildVerifyButton(),

                    const SizedBox(height: 20),

                    // ==================================================
                    // RESEND
                    // ==================================================

                    Center(
                      child: buildResendSection(),
                    ),

                    const SizedBox(height: 25),

                    // ==================================================
                    // SECURITY
                    // ==================================================

                    buildSecurityCard(),

                    const SizedBox(height: 22),

                    // ==================================================
                    // SUPPORT
                    // ==================================================

                    Center(
                      child: Column(
                        children: [
                          const Text(
                            'Having trouble verifying your number?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11.2,
                              color: textGrey,
                            ),
                          ),

                          const SizedBox(height: 4),

                          GestureDetector(
                            onTap: () {
                              // Support screen can be connected later.
                            },
                            child: const Text(
                              'Contact Support',
                              style: TextStyle(
                                fontSize: 12.5,
                                color: primaryBlue,
                                fontWeight:
                                    FontWeight.w700,
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
          },
        ),
      ),
    );
  }
}