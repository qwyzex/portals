import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portals/main.dart';
import 'package:portals/pages/profile/edit_profile.dart';
import 'package:portals/pages/profile/settings.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class AccountProfile extends StatefulWidget {
  final Map<String, dynamic>? userData;
  final Future<void> Function() refetchUserData;

  const AccountProfile(
      {super.key, required this.userData, required this.refetchUserData});

  @override
  State<AccountProfile> createState() => _AccountProfileState();
}

class _AccountProfileState extends State<AccountProfile>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 2, vsync: this); // For two tabs: 'Posts' and 'Comments'
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.userData == null) {
      return const Center(child: Text('No user data available.'));
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        centerTitle: true,
        title: GradientText('Account Profile',
            colors: const [AppColors.textColorDim, AppColors.textColor]),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const Settings()));
                },
                iconSize: 28,
                icon: const Icon(Icons.menu)),
          )
        ],
        actionsIconTheme: const IconThemeData(color: AppColors.textColor),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Profile Image
                CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(widget.userData?['photoURL']),
                ),
                const SizedBox(height: 10),

                // NIS
                Text(
                  "NIS: ${widget.userData?['nis']}",
                  style: const TextStyle(
                      fontSize: 14, color: AppColors.textColorDim),
                ),
                const SizedBox(height: 5),

                // Display Name
                Text(
                  widget.userData?['displayName'],
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                CupertinoButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => EditProfile(
                            photoURL: widget.userData?['photoURL'],
                            displayName: widget.userData?['displayName'],
                            nis: widget.userData?['nis'],
                            schoolClass: widget.userData?['class'],
                            showPublic: {
                              'showPublicNIS':
                                  widget.userData?['showPublicNIS'],
                              'showPublicClass':
                                  widget.userData?['showPublicClass'],
                            },
                            postUpdateFunction: widget.refetchUserData),
                      ),
                    );
                  },
                  child: const Text("Edit Profile"),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: "Posts"),
                    Tab(text: "Comments"),
                  ],
                  labelColor: Colors.black,
                  indicatorColor: Colors.blue,
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      // Placeholder for 'Posts'
                      Center(child: Text("Posts will be displayed here")),
                      // Placeholder for 'Comments'
                      Center(child: Text("Comments will be displayed here")),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
