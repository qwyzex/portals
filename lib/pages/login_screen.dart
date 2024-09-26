import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portals/components/custom_snackbar.dart';
import 'package:portals/components/gradient_background.dart';
import 'package:portals/main.dart';
import 'package:portals/pages/create_account.dart';
import 'package:portals/pages/firebasetest.dart';
import 'package:portals/pages/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final TextEditingController _nisController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                        'Login',
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textColor),
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        controller: _nisController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter
                              .digitsOnly, // Accept only digits
                        ],
                        maxLength: 5,
                        decoration: InputDecoration(
                          counterText: '',
                          hintText: 'NIS',
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
                      const SizedBox(height: 16),
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
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle:
                              const TextStyle(color: AppColors.textColorDim),
                          filled: true,
                          fillColor: AppColors.primaryLighter,
                          // Border properties
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.transparent, // Default border color
                              width: 3.0, // Change thickness here
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors
                                  .focusedBorderColor, // Color when focused
                              width: 3.0, // Change thickness here
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.red, // Color for error state
                              width: 3.0, // Change thickness here
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16), // Padding
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.only(top: 5.0, left: 10.0),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const FirestorePage()));
                          },
                          child: const Text(
                            'Forgot your password?',
                            style: TextStyle(
                                fontWeight: FontWeight.w100,
                                color: AppColors.primary),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              // Bottom section with login button and sign-up text
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
                          "Doesn't have an account?",
                          style:
                              TextStyle(fontSize: 14, color: AppColors.primary),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const AccountCreationScreen(),
                                transitionDuration:
                                    Duration.zero, // No animation
                                reverseTransitionDuration:
                                    Duration.zero, // No reverse animation
                              ),
                            );
                          },
                          child: const Text(
                            'Create one',
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
                        onPressed: _signIn,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFF897558),
                                  letterSpacing: 2),
                            ),
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

  Future<void> _signIn() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String nis = _nisController.text.trim();

    if (email.isEmpty || password.isEmpty || nis.isEmpty) {
      customSnackbar(
        message: 'Please fill in all fields.',
        context: context,
        backgroundColor: const Color(0xFFFFBF00),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Check if the given NIS is equal to the NIS in the document with email
      final userDocQuery = await _db
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (userDocQuery.docs.isNotEmpty) {
        final userDoc = userDocQuery.docs.first.data();

        if (userDoc['nis'] == nis) {
          await _auth.signInWithEmailAndPassword(
              email: email, password: password);

          if (!mounted) return;
          customSnackbar(
            message: 'Successfully signed in.',
            context: context,
            backgroundColor: const Color(0xFF32CD32),
          );
        } else {
          if (!mounted) return;
          customSnackbar(
            message: 'NIS does not match.',
            context: context,
            backgroundColor: const Color(0xFFD22B2B),
          );
        }

        if (!mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (Route<dynamic> route) => false, // Remove all previous routes
        );
      } else {
        if (!mounted) return;
        customSnackbar(
          message: 'No user found with this email.',
          context: context,
          backgroundColor: const Color(0xFFD22B2B),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      customSnackbar(
        message: 'Failed to sign in: ${e.message}',
        context: context,
        backgroundColor: const Color(0xFFD22B2B),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
