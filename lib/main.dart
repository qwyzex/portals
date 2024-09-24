import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'components/custom_button.dart';
import 'pages/opening_slides.dart';

void main() {
  runApp(const MyApp());
}

class AppColors {
  static const Color primary = Color(0xFFFFE5C7);
  static const Color primaryLighter = Color(0xFFFEF1E1);
  static const Color secondary = Color(0xFFDC8282);
  static const Color buttonBackground = Color(0xFFFFE5C7);
  static const Color textColor = Color(0xFF897558);
  static const Color textColorDim = Color(0xFFAC987C);
  static const Color focusedBorderColor = Color(0xFF897558);
  // Add more colors as needed
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gradient Background App',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          fontFamily: 'Lexend',
          primaryColor: AppColors.primary),
      home: const GradientBackgroundScreen(),
    );
  }
}

class GradientBackgroundScreen extends StatefulWidget {
  const GradientBackgroundScreen({super.key});

  @override
  _GradientBackgroundScreenState createState() =>
      _GradientBackgroundScreenState();
}

class _GradientBackgroundScreenState extends State<GradientBackgroundScreen> {
  Color buttonColor = const Color(0xFFFFE5C7);
  double buttonWidth = 330;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image widget for the logo
                    Image.asset(
                      'assets/images/logosmansa.png', // Path to your logo image
                      height: 150, // Adjust the height as needed
                      width: 150, // Adjust the width as needed
                    ),
                    const SizedBox(height: 20), // Space between logo and title
                    GradientText(
                      'portalsmansa',
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                      colors: const [Colors.white, AppColors.primary],
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child: Center(
                  child: SizedBox(
                    width: 330,
                    child: CustomButton(
                      // Use the custom button here
                      text: 'Get Started',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SlidesPage()),
                        );
                      },
                    ),
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
