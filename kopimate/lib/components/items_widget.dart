import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kopimate/models/coffee_model.dart';
import '../screens/single_forum.dart';

class ItemsWidget extends StatefulWidget {
  ItemsWidget({super.key});

  @override
  State<ItemsWidget> createState() => _ItemsWidgetState();
}

class _ItemsWidgetState extends State<ItemsWidget> {
  
  List img = [
    CoffeeModel("Latte"),
    CoffeeModel('Espresso'),
    CoffeeModel('Black Coffee'),
    CoffeeModel('Cold Coffee'),
    CoffeeModel('Vietnamese Iced Coffee'),
  ];


  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: ScrollPhysics(),
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: (150/195),
      children: [
        for (int i = 0; i < img.length; i++) 
          Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 13),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color.fromARGB(255, 30, 29, 28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  spreadRadius: 1,
                  blurRadius: 9,
                )
              ]
            ),
            child: Column(children: [
              /*InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SingleForumScreen(img[i].coffee_name)));
                },
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Image.asset(
                    "lib/images/${img[i].coffee_name}.png",
                    width: 120,
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                ),
              ), */
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      Text(
                        img[i].coffee_name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Color(0xFfe57734),
                          borderRadius: BorderRadius.circular(20), 
                        ),
                        child: Icon(
                          CupertinoIcons.bubble_left_bubble_right_fill,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                    ),
                    ),
            ],
            ),
          ),
      ],
    );
  }
}