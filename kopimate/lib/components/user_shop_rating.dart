import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'delete_button.dart';

class UserShopRating extends StatefulWidget {
  final String type;
  final String msg;
  final String user;
  final String postId;
  final double rating;

  const UserShopRating(
      {super.key,
      required this.type,
      required this.msg,
      required this.user,
      required this.postId,
      required this.rating});

  @override
  State<UserShopRating> createState() => _UserShopRatingState();
}

class _UserShopRatingState extends State<UserShopRating> {
  //user
  final user = FirebaseAuth.instance.currentUser!;

  //user rating
  void leaveRating() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Rate this Shop"),
        content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,children: [
          const Text("Leave a rating!", style: TextStyle(fontSize: 20)),
          const SizedBox(height: 20),
          RatingBar.builder(
            initialRating: 0,
            itemSize: 40,
            itemBuilder: (context, _) =>
                Icon(Icons.coffee, color: Colors.amber),
            onRatingUpdate: (rating) => setState(() {
              FirebaseFirestore.instance
                  .collection("${widget.type} Reviews")
                  .doc(widget.postId)
                  .update({'Rating': rating});
            }),
          ),
        ]),
        actions: [
          //ok button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
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
        title: const Text("Delete Review"),
        content: const Text("Are you sure you want to delete this rating?"),
        actions: [
          //cancel button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),

          //delete button
          TextButton(
            onPressed: () async {
              //then delete post
              FirebaseFirestore.instance
                  .collection("${widget.type} Reviews")
                  .doc(widget.postId)
                  .delete()
                  .then((value) => print("review deleted"))
                  .catchError(
                      (error) => print("failed to delete review: $error"));

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
      margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //rating
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //(message + user email)
              Column(
                children: [
                  //message
                  SizedBox(
                    width: double.infinity,
                    child: Text(widget.msg),
                  ),

                  const SizedBox(height: 5),
                  //email
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      widget.user,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //rating bar
                        Row(children: [
                          RatingBar.builder(
                            ignoreGestures: true,
                            initialRating: widget.rating,
                            itemSize: 20,
                            itemBuilder: (context, _) =>
                                Icon(Icons.coffee, color: Colors.amber),
                            onRatingUpdate: (rating) => setState(() {
                              FirebaseFirestore.instance
                                  .collection("${widget.type} Reviews")
                                  .doc(widget.postId)
                                  .update({'Rating': rating});
                            }),
                          ),
                          //rating button
                          if (widget.user == user.email)
                          TextButton(
                              onPressed: () => leaveRating(),
                              child: const Text('Rate?')),
                        ]),

                        if (widget.user == user.email)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              //delete button
                              DeleteButton(onTap: deletePost),
                              const SizedBox(width: 5),
                              const Text('Delete Review'),
                            ],
                          ),
                      ]),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
