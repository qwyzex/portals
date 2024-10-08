import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portals/components/custom_snackbar.dart';
import 'package:portals/main.dart';
import 'package:portals/pages/home_screen.dart';
import 'package:portals/pages/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PasswordResetPage extends StatefulWidget {
  const PasswordResetPage({super.key});

  @override
  State<PasswordResetPage> createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      // If user is already signed in, redirect to Home
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFCDCB7),
                Color(0xFFDC8282),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Back button at the top
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Navigator.canPop(context)
                          ? Colors.black.withOpacity(0.2)
                          : Colors.transparent, // Semi-transparent background
                      borderRadius: BorderRadius.circular(
                          50.0), // Optional: rounded corners
                    ),
                    child: Navigator.canPop(context)
                        ? IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.keyboard_arrow_left_rounded,
                                color: Colors.white),
                          )
                        : const SizedBox(
                            height: 48,
                            width: 48,
                          ),
                  ),
                ),
              ),
              // Title and text fields container
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(left: 36, right: 36, top: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Reset Password',
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textColor),
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle:
                              const TextStyle(color: AppColors.textColorDim),
                          filled: true,
                          fillColor: AppColors.primaryLighter,
                          // Border properties
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.transparent, // Default border color
                              width: 3, // Change thickness here
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors
                                  .focusedBorderColor, // Color when focused
                              width: 3, // Change thickness here
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.red, // Color for error state
                              width: 3, // Change thickness here
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16), // Padding
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Bottom section with create account button and sign-in text
              Padding(
                padding:
                    const EdgeInsets.only(bottom: 50.0, left: 50, right: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Remember your password already?",
                          style:
                              TextStyle(fontSize: 14, color: AppColors.primary),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // Navigator.pushReplacement(
                            //   context,
                            //   PageRouteBuilder(
                            //     pageBuilder:
                            //         (context, animation, secondaryAnimation) =>
                            //             const LoginScreen(),
                            //     transitionDuration:
                            //         Duration.zero, // No animation
                            //     reverseTransitionDuration:
                            //         Duration.zero, // No reverse animation
                            //   ),
                            // );
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: CupertinoColors.white,
                        borderRadius:
                            BorderRadius.circular(12.0), // Rounded corners
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withOpacity(0.15), // Shadow color
                            spreadRadius: 3, // Spread radius
                            blurRadius: 8, // Blur radius
                            offset: const Offset(0, 5), // Offset of the shadow
                          ),
                        ],
                      ),
                      child: CupertinoButton(
                        color: const Color(0xFFFCDCB7),
                        onPressed: _sendResetEmail,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Send Link',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFF897558),
                                  letterSpacing: 2),
                            ),
                            _isLoading
                                ? const CircularProgressIndicator()
                                : const Text(''),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sendResetEmail() async {
    final String email = _emailController.text.trim();

    if (email.isEmpty) {
      customSnackbar(
          message: "Please fill in the email address", context: context);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.sendPasswordResetEmail(email: email);

      // Check if widget is still mounted before navigating
      if (!mounted) return;
    } on FirebaseAuthException catch (e) {
      customSnackbar(
          message: "Failed to create account: ${e.message}",
          context: context,
          backgroundColor: Colors.redAccent);
    } finally {
      if (mounted) {
        customSnackbar(
            message: "Please check your mailbox for link to reset password",
            context: context,
            backgroundColor: Colors.greenAccent);
        _emailController.clear();
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
