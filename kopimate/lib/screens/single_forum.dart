import 'package:flutter/material.dart';
import 'package:kopimate/models/coffee_model.dart';

class SingleForumScreen extends StatefulWidget {
  
  final CoffeeModel coffee_type;
 
  SingleForumScreen({required this.coffee_type});

  @override
  State<SingleForumScreen> createState() => _SingleForumScreenState();
}

class _SingleForumScreenState extends State<SingleForumScreen> {

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(widget.coffee_type.coffee_name!),
        elevation: 0,
        actions: [
        //go back to homepage
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            }, 
            icon: Icon(Icons.arrow_back),
          ),
        ],
      ),
      body: Column(
        children: [
          //forum

          //post message
        ],
      ),
    );
  }
}