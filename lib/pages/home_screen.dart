import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portals/components/custom_button.dart';
import 'package:portals/pages/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? documentData;

  Future<void> fetchDocument() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc('wNI1GjK2KMTO9muTIEuLtqv3K8o2')
          .get();

      setState(() {
        documentData = documentSnapshot.data() as Map<String, dynamic>?;
      });
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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Transparent status bar
        statusBarIconBrightness: Brightness.dark, // Dark icons
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: documentData == null
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show a loader while waiting for the data
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'User Data:',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      // Render the document data
                      Text("NIS: ${documentData?['nis']}"),
                      Text("Email: ${documentData?['email']}"),
                      Text("UID: ${documentData?['uid']}"),
                      Text("Date Created: ${documentData?['createdAt']}"),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 330,
                  child: CustomButton(
                    buttonColor: Colors.red,
                    textColor: Colors.white,
                    text: 'Log Out',
                    onPressed: signOut,
                  ),
                ),
              ],
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
      _showSnackBar("Failed to create account: ${error.message}");
    }
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
