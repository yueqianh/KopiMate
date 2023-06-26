import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kopimate/components/user_textfield.dart';
import 'package:kopimate/models/coffee_model.dart';
import '../../components/post.dart';

class ForumDetails extends StatefulWidget {
  final CoffeeModel coffee_type;

  ForumDetails({required this.coffee_type});

  @override
  State<ForumDetails> createState() => _ForumDetailsState();
}

class _ForumDetailsState extends State<ForumDetails> {
//user
  final user = FirebaseAuth.instance.currentUser!;

//text controller
  final textController = TextEditingController();

//post message function
  void post() {
    //error if post is empty
    if (textController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            backgroundColor: Colors.white,
            title: Center(
              child: Text(
                'Unable to create post',
                style: TextStyle(color: Colors.black),
              ),
            ),
          );
        },
      );
    }
    //only post if box is not empty
    if (textController.text.isNotEmpty) {
      //store in firebase
      FirebaseFirestore.instance
          .collection("${widget.coffee_type.coffee_name!} Posts")
          .add({
        'UserEmail': user.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text('${widget.coffee_type.coffee_name!} Forum'),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: [
            // Forum posts
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("${widget.coffee_type.coffee_name!} Posts")
                    .orderBy(
                      "TimeStamp",
                      descending: false,
                    )
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        //get message
                        final post = snapshot.data!.docs[index];
                        return Post(
                          type: widget.coffee_type.coffee_name!,
                          msg: post['Message'],
                          user: post['UserEmail'],
                          postId: post.id,
                          likes: List<String>.from(post['Likes'] ?? []),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error:${snapshot.error}'),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),

            // Textbox for posting
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Row(
                  children: [
                    // using custom textfield
                    Expanded(
                      child: UserTextField(
                        controller: textController,
                        hintText: "Post your coffee-making tricks!",
                        obscureText: false,
                      ),
                    ),
                    // post button
                    IconButton(
                      iconSize: 30,
                      onPressed: post,
                      icon: const Icon(Icons.arrow_circle_up),
                    ),
                  ],
                ),
              ),
            ),

            // logged in as
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text("Logged in as: ${user.email!}")),
          ],
        ),
      ),
    );
  }
}
