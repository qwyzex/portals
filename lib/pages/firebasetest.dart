import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FirestorePage extends StatefulWidget {
  const FirestorePage({super.key});

  @override
  _FirestorePageState createState() => _FirestorePageState();
}

class _FirestorePageState extends State<FirestorePage> {
  // Variable to store document data
  Map<String, dynamic>? documentData;

  // Function to fetch document data
  Future<void> fetchDocument() async {
    try {
      // Reference to the specific document inside the 'anonymous' collection
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('anonymous')
          .doc('ikfHa8QNYuGOpP9bRaUr') // Replace with your document ID
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
        title: const Text('Firestore Test'),
      ),
      body: documentData == null
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show a loader while waiting for the data
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Document Data:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  // Render the document data
                  Text(documentData.toString()),
                ],
              ),
            ),
    );
  }
}
