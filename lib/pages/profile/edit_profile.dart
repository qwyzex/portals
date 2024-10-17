import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portals/main.dart';
import 'package:portals/pages/profile/settings.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

const List<String> classList = <String>[
  'X.1',
  'X.2',
  'X.3',
  'X.4',
  'X.5',
  'X.6',
  'X.7',
  'X.8',
  'X.9',
  'XI.1',
  'XI.2',
  'XI.3',
  'XI.4',
  'XI.5',
  'XI.6',
  'XI.7',
  'XI.8',
  'XI.9',
  'XI.10',
  'XII.1',
  'XII.2',
  'XII.3',
  'XII.4',
  'XII.5',
  'XII.6',
  'XII.7',
  'XII.8',
  'XII.9',
];

class EditProfile extends StatefulWidget {
  final String nis;
  final String schoolClass;
  final String displayName;
  final String photoURL;
  final Map<String, bool> showPublic;
  final Future<void> Function() postUpdateFunction;

  const EditProfile({
    super.key,
    required this.photoURL,
    required this.displayName,
    required this.nis,
    required this.schoolClass,
    required this.showPublic,
    required this.postUpdateFunction,
  });

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController _displayNameController = TextEditingController();
  String? dropdownValue = classList.first;
  bool showPublicNIS = false;
  bool showPublicClass = false;

  Map<String, dynamic>? userData; // To store the user document data

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

  Future<void> updateUserData() async {
    final User? user = _auth.currentUser;

    if (user != null) {
      try {
        await _firestore.collection('users').doc(user.uid).update({
          'displayName': _displayNameController.text,
          'class': dropdownValue,
          'showPublicClass': showPublicClass,
          'showPublicNIS': showPublicNIS,
        }).then(
          (value) => {
            if (mounted)
              {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile Updated!')),
                ),
                widget.postUpdateFunction(),
                Navigator.pop(context)
              }
          },
        );
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController(text: widget.displayName);

    // SETTING VALUES
    dropdownValue = widget.schoolClass;
    showPublicClass = widget.showPublic['showPublicClass']!;
    showPublicNIS = widget.showPublic['showPublicNIS']!;
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            toolbarHeight: 70,
            centerTitle: true,
            title: const Text('Edit Profile'),
            actionsIconTheme: const IconThemeData(color: AppColors.textColor),
            actions: [
              CupertinoButton(
                onPressed: updateUserData,
                child: const Text('SAVE'),
              )
            ],
            leadingWidth: 100,
            leading: CupertinoButton(
                child: const Text('DISCARD'),
                onPressed: () {
                  Navigator.pop(context);
                })),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
              child: SingleChildScrollView(
                  // padding: const EdgeInsets.only(left: 36, right: 36, top: 12),
                  child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      decoration:
                          BoxDecoration(shape: BoxShape.circle, boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.15),
                          spreadRadius: 5,
                          blurRadius: 7,
                        )
                      ]),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(widget.photoURL),
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("#${widget.nis}"),
                        const SizedBox(
                          height: 10,
                        ),
                        CupertinoButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () {},
                            child: const Text("Edit Profile Picture")),
                        CupertinoButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () {},
                            child: const Text("Remove Profile Picture")),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Name:'),
                    const SizedBox(
                      height: 6,
                    ),
                    TextField(
                      maxLength: 60,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      maxLines: 1,
                      controller: _displayNameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your name',
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: const Text('Class'),
                trailing: DropdownMenu(
                    initialSelection: classList
                        .where((element) => widget.schoolClass == element)
                        .first,
                    onSelected: (value) {
                      setState(() {
                        dropdownValue = value.toString();
                      });
                    },
                    dropdownMenuEntries: classList
                        .map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                          value: value, label: value);
                    }).toList()),
              ),
              ListTile(
                title: const Text('Show NIS to public'),
                onTap: () {
                  setState(() {
                    showPublicNIS = !showPublicNIS;
                  });
                },
                trailing: Switch(
                    activeColor: AppColors.textColor,
                    value: showPublicNIS,
                    onChanged: (bool value) {
                      setState(() {
                        showPublicNIS = value;
                      });
                    }),
              ),
              ListTile(
                title: const Text('Show class to public'),
                onTap: () {
                  setState(() {
                    showPublicClass = !showPublicClass;
                  });
                },
                trailing: Switch(
                    activeColor: AppColors.textColor,
                    value: showPublicClass,
                    onChanged: (bool value) {
                      setState(() {
                        showPublicClass = value;
                      });
                    }),
              ),
            ],
          )))
        ]));
  }
}
