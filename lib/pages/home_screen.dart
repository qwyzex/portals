import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portals/components/custom_button.dart';
import 'package:portals/components/custom_snackbar.dart';
import 'package:portals/main.dart';
import 'package:portals/pages/profile/account_profile.dart';
import 'package:portals/pages/home/home_feed.dart';
import 'package:portals/pages/auth/login_screen.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? userData; // To store the user document data
  List<Map<String, dynamic>> postsData = [];
  bool _isLoading = true;

  // Function to fetch the user document
  Future<void> fetchUserData() async {
    final User? user = _auth.currentUser;

    if (user != null) {
      try {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        setState(() {
          userData = userDoc.data() as Map<String, dynamic>;
        });
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }

  // Function to fetch all posts
  Future<void> fetchPosts() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('posts').get();

      setState(() {
        postsData = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error retrieving posts: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchPosts();
  }

  // state of tabs open, home or profile
  int openedTab = 1;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      body: openedTab == 2
          ? AccountProfile(
              userData: userData,
              refetchUserData: fetchUserData,
            )
          : HomeFeed(postsData: postsData, refetchPosts: fetchPosts),
      bottomNavigationBar: BottomAppBar(
        elevation: 2.0,
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
