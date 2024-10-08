import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portals/components/custom_snackbar.dart';
import 'package:portals/main.dart';
import 'package:portals/pages/home_screen.dart';
import 'package:portals/pages/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart'; // To parse Excel files

class AccountCreationScreen extends StatefulWidget {
  const AccountCreationScreen({super.key});

  @override
  _AccountCreationScreenState createState() => _AccountCreationScreenState();
}

class _AccountCreationScreenState extends State<AccountCreationScreen> {
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
                        'Create Account',
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
                          "Already have an account?",
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
                                        const LoginScreen(),
                                transitionDuration:
                                    Duration.zero, // No animation
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
                        onPressed: _createAccount,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Create Account',
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

  Future<void> _createAccount() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String nis = _nisController.text.trim();

    if (email.isEmpty || password.isEmpty || nis.isEmpty) {
      _showSnackBar("Please fill in all fields");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    ByteData data = await rootBundle.load('assets/nisdata/nis.xlsx');
    var bytes = data.buffer.asUint8List();

    var excel = Excel.decodeBytes(bytes);

    String? displayName;

    // Iterate through the rows of the first sheet in the Excel file
    for (var table in excel.tables.keys) {
      for (var row in excel.tables[table]!.rows) {
        String nisFromExcel = row[2]?.value.toString() ?? '';
        if (nis == nisFromExcel) {
          displayName = row[1]?.value.toString();
          break;
        }
      }
      if (displayName != null) break;
    }

    if (displayName == null) {
      // throw Exception('NIS is invalid.');
      if (!mounted) return;
      customSnackbar(
          message: 'NIS is invalid.',
          context: context,
          backgroundColor: Colors.redAccent);
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      return;
    }

    try {
      UserCredential justCreatedUser = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = justCreatedUser.user;

      if (user != null) {
        await _db.collection("users").doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'nis': _nisController.text.trim(),
          'displayName': displayName,
          'createdAt': FieldValue.serverTimestamp(),
        });

        await user.sendEmailVerification();
      }

      // Check if widget is still mounted before navigating
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      _showSnackBar("Failed to create account: ${e.message}");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
