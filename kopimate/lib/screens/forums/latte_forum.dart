import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kopimate/components/user_textfield.dart';
import 'package:kopimate/models/coffee_model.dart';
import '../../components/posts/latte_post.dart';


class LatteForum extends StatefulWidget {
  
  final CoffeeModel coffee_type;
  
  LatteForum({required this.coffee_type});

  @override
  State<LatteForum> createState() => _LatteForumState();
}

class _LatteForumState extends State<LatteForum> {

//user
final user = FirebaseAuth.instance.currentUser!;

//text controller
final textController = TextEditingController();

//post message function
void post() {
  //only post if box is not empty
  if (textController.text.isNotEmpty) {
    //store in firebase
    FirebaseFirestore.instance.collection("Latte Posts").add({
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
        title: Text(widget.coffee_type.coffee_name!),
        elevation: 0,
        backgroundColor: Colors.grey[900],
        /*actions: [
        //go back to homepage
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            }, 
            icon: Icon(Icons.arrow_back),
          ),
        ],*/
      ),
      
      body: Center(
        child: Column(
          children: [
            //forum
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                .collection("Latte Posts")
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
                        return LattePost(
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
      
            //post message
            Padding(
              padding: const EdgeInsets.all(25),
              child: Row(
                children: [
                  //textfield
                  Expanded(
                    child: UserTextField(
                      controller: textController, 
                      hintText: "Post your coffee-making tricks!", 
                      obscureText: false,
                      ),
                    ),
            
                  //post button
                  IconButton(
                    onPressed: post, 
                    icon: const Icon(Icons.arrow_circle_up),
                    )
                ],
              ),
            ),
      
            //logged in as
            Text("Logged in as: ${user.email!}"),
          ],
        ),
      ),
    );
  }
}