import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portals/components/custom_button.dart';
import 'package:portals/components/custom_snackbar.dart';
import 'package:portals/main.dart';
import 'package:portals/pages/login_screen.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? documentData;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // state of tabs open, home or profile
  int openedTab = 1;

  Future<void> fetchDocument() async {
    final User? user = _auth.currentUser;

    try {
      if (user != null) {
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        setState(() {
          documentData = documentSnapshot.data() as Map<String, dynamic>?;
        });
      }
    } catch (e) {
      print('Error retrieving document: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch the document when the page is loaded
    fetchDocument();
  }

  // @override
  // Widget build(BuildContext context) {
  //   SystemChrome.setSystemUIOverlayStyle(
  //     const SystemUiOverlayStyle(
  //       statusBarColor: Colors.transparent, // Transparent status bar
  //       statusBarIconBrightness: Brightness.dark, // Dark icons
  //     ),
  //   );

  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Home'),
  //     ),
  //     body: documentData == null
  //         ? const Center(
  //             child:
  //                 CircularProgressIndicator()) // Show a loader while waiting for the data
  //         : Column(
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.all(16.0),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     const Text(
  //                       'User Data:',
  //                       style: TextStyle(
  //                           fontSize: 20, fontWeight: FontWeight.bold),
  //                     ),
  //                     const SizedBox(height: 10),
  //                     // Render the document data
  //                     Text("NIS: ${documentData?['nis']}"),
  //                     Text("Email: ${documentData?['email']}"),
  //                     Text("UID: ${documentData?['uid']}"),
  //                     Text("Date Created: ${documentData?['createdAt']}"),
  //                   ],
  //                 ),
  //               ),
  //               const SizedBox(
  //                 height: 20,
  //               ),
  //               SizedBox(
  //                 width: 330,
  //                 child: CustomButton(
  //                   buttonColor: Colors.red,
  //                   textColor: Colors.white,
  //                   text: 'Log Out',
  //                   onPressed: signOut,
  //                 ),
  //               ),
  //             ],
  //           ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Center(
          child: GradientText('portalsmansa',
              colors: const [AppColors.textColor, AppColors.textColorDim]),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(color: AppColors.background),
        child: Center(
          child: Text(openedTab == 1 ? 'HOME' : 'PROFILE'),
        ),
      ),
      bottomSheet: BottomAppBar(
        elevation: 2.0,
        color: AppColors.background,
        height: 60,
        padding: const EdgeInsets.all(0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 120,
              height: 60,
              child: IconButton(
                  icon: Icon(
                    openedTab == 1 ? Icons.home_rounded : Icons.home_outlined,
                  ),
                  iconSize: 35,
                  onPressed: () {
                    setState(() {
                      openedTab = 1;
                    });
                  },
                  color: openedTab == 1
                      ? AppColors.textColor
                      : AppColors.textColorDim),
            ),
            SizedBox(
              width: 120,
              height: 60,
              child: IconButton(
                icon: Icon(openedTab == 2
                    ? Icons.account_circle_rounded
                    : Icons.account_circle_outlined),
                iconSize: 35,
                onPressed: () {
                  setState(() {
                    openedTab = 2;
                  });
                },
                color: openedTab == 2
                    ? AppColors.textColor
                    : AppColors.textColorDim,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } on FirebaseAuthException catch (error) {
      customSnackbar(
          message: "Failed to create account: ${error.message}",
          context: context);
    } finally {
      customSnackbar(message: 'Successfully logged out', context: context);
    }
  }
}
