
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kopimate/components/like_button.dart';
import 'package:kopimate/helper/helper.dart';
import '../delete_button.dart';
import '../comment_button.dart';
import '../comment.dart';


class AmericanoPost extends StatefulWidget {
  final String msg;
  final String user;
  final String postId;
  final List<String> likes;
 
  
  const AmericanoPost({
    super.key, 
    required this.msg, 
    required this.user, 
    required this.postId,
    required this.likes,
  });

  @override
  State<AmericanoPost> createState() => _AmericanoPostState();
}

class _AmericanoPostState extends State<AmericanoPost> {

  //user
  final user = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  //comment text controller
  final commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(user.email);
  }

  //toggle like
  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    //Access the document in Firebase
    DocumentReference postRef =
      FirebaseFirestore.instance.collection('Americano Posts').doc(widget.postId);

    if (isLiked) {
      //add user email to "Likes" field
      postRef.update({
        'Likes': FieldValue.arrayUnion([user.email])
      });
    } else {
      //remove the user from "Likes" field
      postRef.update({
        'Likes': FieldValue.arrayRemove([user.email])
      });
    }
  }

  //add comment
  void comment(String commentText) {
    //write the comment to firestore
    FirebaseFirestore.instance
      .collection("Americano Posts")
      .doc(widget.postId)
      .collection("Comments")
      .add({
        "CommentText": commentText,
        "CommentedBy": user.email,
        "CommentTime": Timestamp.now()
      });
  }

  //show dialog box for adding comment
  void showCommentDialog() {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text("Add Comment"),
        content: TextField(
          controller: commentController,
          decoration: InputDecoration(hintText: "Write a comment.."),
        ),
        actions: [
          //post button
          TextButton(
            onPressed: () {
              //add comment
              comment(commentController.text);

              //pop box
              Navigator.pop(context);

              //clear controller
              commentController.clear();
            }, 
            child: Text("Post"),
          ),

          //cancel button
          TextButton(
            onPressed: () {
              //pop box
              Navigator.pop(context);

              //clear controller
              commentController.clear();
            }, 
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  //delete post
  void deletePost() {
    //show a dialog box for confirmation
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text("Delete Post"),
        content: const Text("Are you sure you want to delete this post?"),
        actions: [
          //cancel button
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text("Cancel"),
          ),

          //delete button
          TextButton(
            onPressed: () async {
              //delete comment from firestore
              final commentDocs = await FirebaseFirestore.instance
                .collection("Americano Posts")
                .doc(widget.postId)
                .collection("Comments")
                .get();
              
              for (var doc in commentDocs.docs) {
                await FirebaseFirestore.instance
                  .collection("Americano Posts")
                  .doc(widget.postId)
                  .collection("Comments")
                  .doc(doc.id)
                  .delete();
              }

              //then delete post
              FirebaseFirestore.instance
                .collection("Americano Posts")
                .doc(widget.postId)
                .delete()
                .then((value) => print("post deleted"))
                .catchError(
                  (error) => print("failed to delete post: $error"));

              //dismiss the dialog
              Navigator.pop(context);
            }, 
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.only(top:25, left: 25, right: 25),
        padding: EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //forum post
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //(message + user email)
                Column(
                  children: [
                    //message
                    Text(widget.msg),
          
                    const SizedBox(height: 5),
          
                    //user
                    Text(
                      widget.user,
                      style: TextStyle(color:Colors.grey[500]),
                      ), 
                  ],
                ),
              
                //delete button
                if (widget.user == user.email)
                DeleteButton(onTap: deletePost),
              ],
            ),
          ),

          const SizedBox(height: 20),

          //buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //LIKE
              Column(
                children: [
                  //like button
                  LikeButton(
                    isLiked: isLiked, 
                    onTap: toggleLike,
                  ),

                  const SizedBox(width: 5),

                  //like count
                  Text(widget.likes.length.toString()),
                ],
              ),

              //COMMENT
              Column(
                children: [
                  //comment button
                  CommentButton(
                    onTap: showCommentDialog,
                  ),

                  const SizedBox(height: 5),

                  //comment count
                  Text('...'),
                  
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          //display comments
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
              .collection("Americano Posts")
              .doc(widget.postId)
              .collection("Comments")
              .orderBy("CommentTime", descending: true).snapshots(),
            builder: (context, snapshot) {
              //show loading circle if no data yet
              if(!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView(
                shrinkWrap: true, //for nested lists
                physics: const NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((doc) {
                  //get comment
                  final commentData = doc.data() as Map<String, dynamic>;
                  
                  //return comment
                  return Comment(
                    text: commentData["CommentText"], 
                    user: commentData["CommentedBy"], 
                    time: formatDate(commentData["CommentTime"]),
                  );
                }).toList(),
              );
            },
          )
        ],
      ),
    );
  }
}