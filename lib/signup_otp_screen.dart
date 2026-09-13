import 'package:flutter/material.dart';
import 'homescreen.dart';

class SignupOtpScreen extends StatefulWidget {
  final String phoneNumber;

  const SignupOtpScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<SignupOtpScreen> createState() => _SignupOtpScreenState();
}

class _SignupOtpScreenState extends State<SignupOtpScreen> {
  final otpController = TextEditingController();

  static const Color primaryBlue = Color(0xFF1769E0);
  static const Color darkBlue = Color(0xFF123B70);
  static const Color lightBlue = Color(0xFFF4F8FF);

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  void verifyOtp() {
    if (otpController.text.trim().length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 6-digit OTP'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Dummy OTP verification for now
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // Important:
      // Keyboard open hone par screen resize hogi
      // aur SingleChildScrollView content ko scroll karega.
      resizeToAvoidBottomInset: true,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

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
          'Verify Phone',
          style: TextStyle(
            color: darkBlue,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),

        centerTitle: true,
      ),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,

              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 20,

                // Keyboard open hone par extra space
                // automatically add hogi.
                bottom: MediaQuery.of(context).viewInsets.bottom + 30,
              ),

              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 20,
                ),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    const SizedBox(height: 20),

                    // ------------------------------------------------
                    // OTP ICON
                    // ------------------------------------------------

                    Container(
                      height: 80,
                      width: 80,
                      decoration: const BoxDecoration(
                        color: lightBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.sms_outlined,
                        size: 42,
                        color: primaryBlue,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ------------------------------------------------
                    // TITLE
                    // ------------------------------------------------

                    const Text(
                      'Verify Your Phone Number',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                        color: darkBlue,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'We sent a 6-digit OTP to',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 6),

                  

                    Text(
                      '+91 ${widget.phoneNumber}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: primaryBlue,
                      ),
                    ),

                    const SizedBox(height: 28),

                   

                    TextField(
                      controller: otpController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      maxLength: 6,
                      autofocus: false,
                      textAlign: TextAlign.center,

                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 7,
                      ),

                      onSubmitted: (_) {
                        verifyOtp();
                      },

                      decoration: InputDecoration(
                        hintText: '------',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          letterSpacing: 7,
                        ),

                        counterText: '',

                        filled: true,
                        fillColor: lightBlue,

                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 18,
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: primaryBlue,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                   
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: verifyOtp,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBlue,
                          foregroundColor: Colors.white,
                          elevation: 2,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),

                        child: const Text(
                          'Verify & Continue',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    

                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'OTP resent successfully',
                            ),
                          ),
                        );
                      },

                      child: const Text(
                        'Resend OTP',
                        style: TextStyle(
                          color: primaryBlue,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
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