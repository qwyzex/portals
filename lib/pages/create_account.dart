import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portals/main.dart';
import 'package:portals/pages/login_screen.dart';

class AccountCreationScreen extends StatelessWidget {
  const AccountCreationScreen({super.key});

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
                      color: Colors.black
                          .withOpacity(0.2), // Semi-transparent background
                      borderRadius: BorderRadius.circular(
                          50.0), // Optional: rounded corners
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.keyboard_arrow_left_rounded,
                          color: Colors.white),
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
                        'Create Account',
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textColor),
                      ),
                      const SizedBox(height: 30),
                      TextField(
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
                    ],
                  ),
                ),
              ),
              // Bottom section with create account button and sign-in text
              const BottomFun(),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomFun extends StatelessWidget {
  const BottomFun({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0, left: 50, right: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Already have an account?",
                style: TextStyle(fontSize: 14, color: AppColors.primary),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const LoginScreen(),
                      transitionDuration: Duration.zero, // No animation
                      reverseTransitionDuration:
                          Duration.zero, // No reverse animation
                    ),
                  );
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
              borderRadius: BorderRadius.circular(12.0), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15), // Shadow color
                  spreadRadius: 3, // Spread radius
                  blurRadius: 8, // Blur radius
                  offset: const Offset(0, 5), // Offset of the shadow
                ),
              ],
            ),
            child: CupertinoButton(
              color: const Color(0xFFFCDCB7),
              onPressed: () {},
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Create Account',
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
    );
  }
}
