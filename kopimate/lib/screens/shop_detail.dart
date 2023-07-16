
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kopimate/components/user_shop_rating.dart';
import 'package:kopimate/services/firebase_storage_service.dart';
import 'package:maps_launcher/maps_launcher.dart';
import '../components/user_textfield.dart';
import '../models/shop.dart';



class ShopDetail extends StatefulWidget {
  final Shop shop;
  
  ShopDetail({Key? key, required this.shop}) : super(key: key);

  @override
  State<ShopDetail> createState() => _ShopDetailState();
}

class _ShopDetailState extends State<ShopDetail> {
  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
    
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
                'Unable to create review',
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
          .collection("${widget.shop.name} Reviews")
          .add({
        'UserEmail': user.email,
        'Review': textController.text,
        'TimeStamp': Timestamp.now(),
        'Rating': 0,
      });
    }
  }
    
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: CustomScrollView(
        slivers: <Widget>[
          //sliver app bar
          SliverAppBar.medium(
            expandedHeight: 300.0,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const <StretchMode>[
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
                StretchMode.fadeTitle,
              ],
              title: Text(
                widget.shop.name,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              titlePadding: const EdgeInsets.all(20),
              background: SizedBox(
                child: Stack(fit: StackFit.expand, children: [
                  FutureBuilder(
                      future: storage.downloadURL(widget.shop.imgName),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          return Image.network(
                            snapshot.data!,
                            fit: BoxFit.cover,
                          );
                        }
                        if (snapshot.connectionState ==
                                ConnectionState.waiting ||
                            !snapshot.hasData) {
                          return const CircularProgressIndicator();
                        }
                        return Container();
                      }),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.0, 0.3),
                        end: Alignment.topCenter,
                        colors: <Color>[
                          Color.fromARGB(150, 0, 0, 0),
                          Color(0x00000000),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ),
            actions: <Widget>[
              IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
            ],
          ),
          
          //direction
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                ListTile(
                  leading: const Icon(Icons.map),
                  minLeadingWidth: 10,
                  title: Text(widget.shop.address),
                  subtitle: const Text('Click to find directions'),
                  onTap: () {
                    MapsLauncher.launchQuery(widget.shop.address);
                  },
                ),
                // ListTiles++
              ],
            ),
          ),

          //user ratings
          SliverToBoxAdapter(
            child: Expanded(
              child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("${widget.shop.name} Reviews")
                        .orderBy(
                          "TimeStamp",
                          descending: false,
                        )
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            //get message
                            final post = snapshot.data!.docs[index];
                            return UserShopRating(
                              type: widget.shop.name,
                              msg: post['Review'],
                              user: post['UserEmail'],
                              rating: post['Rating'].toDouble(),
                              postId: post.id,                          
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
          ),
          
          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // Textbox for posting
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Row(
                    children: [
                      // using custom textfield
                      Expanded(
                        child: UserTextField(
                          controller: textController,
                          hintText: "Leave a review!",
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
            ),

            // logged in as
            SliverToBoxAdapter(
              child: Center(
                  child: Text("Logged in as: ${user.email!}")),
            ),           
        ],
      ),           
      );
    /*
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text(
                widget.shop.name,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
      ),
      body: Center(
        child: Column(
          children: [
            //picture of the shop
            FutureBuilder(
                       future: storage.downloadURL(widget.shop.imgName),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          return Image.network(
                            snapshot.data!,
                            fit: BoxFit.cover,
                          );
                        }
                        if (snapshot.connectionState ==
                                ConnectionState.waiting ||
                            !snapshot.hasData) {
                          return const CircularProgressIndicator();
                        }
                        return Container();
                      }),
            

            //button to lead to google maps location
             ListTile(
                  leading: const Icon(Icons.map),
                  minLeadingWidth: 10,
                  title: Text(widget.shop.address),
                  subtitle: const Text('Click to find directions'),
                  onTap: () {
                    MapsLauncher.launchQuery(widget.shop.address);
                  },
                ),

            //User ratings
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("${widget.shop.name} Ratings")
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
                        return UserShopRating(
                          type: widget.shop.name,
                          msg: post['Rating'],
                          user: post['UserEmail'],
                          postId: post.id,                          
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
                        hintText: "Leave a rating!",
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
    */
  }
}

