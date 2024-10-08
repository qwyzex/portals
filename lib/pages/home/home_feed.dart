import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portals/main.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class HomeFeed extends StatefulWidget {
  final List<Map<String, dynamic>> postsData; // Passed from HomeScreen
  final VoidCallback refetchPosts; // Function to refetch posts

  const HomeFeed(
      {super.key, required this.postsData, required this.refetchPosts});
  // const HomeFeed({});

  @override
  State<HomeFeed> createState() => _HomeFeedState();
}

class _HomeFeedState extends State<HomeFeed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        centerTitle: true,
        title: GradientText('portalsmansa',
            colors: const [AppColors.textColorDim, AppColors.textColor]),
        actionsIconTheme: const IconThemeData(color: AppColors.textColor),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          widget
              .refetchPosts(); // Call the refetch function when user pulls to refresh
        },
        child: ListView.builder(
          itemCount: widget.postsData.length,
          itemBuilder: (context, index) {
            var post = widget.postsData[index];
            String postedBy = post['postedBy'] ?? 'Unknown User';
            String caption = post['caption'] ?? '';
            int liked = post['liked'] ?? 0;
            Timestamp timestamp = post['timePosted'];
            DateTime timePosted = timestamp.toDate();

            return Card(
              child: ListTile(
                title: Text('Posted by: $postedBy'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Posted on: ${timePosted.toLocal()}'),
                    Text(caption),
                    Text('Likes: $liked'),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
