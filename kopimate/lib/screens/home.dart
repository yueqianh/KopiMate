import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kopimate/screens/forums/americano_forum.dart';
import 'package:kopimate/screens/forums/cold_coffee_forum.dart';
import 'package:kopimate/screens/forums/espresso_forum.dart';
import 'package:kopimate/screens/forums/latte_forum.dart';
import 'package:kopimate/screens/forums/vietnamese_iced_coffe_forum.dart';
import 'package:kopimate/screens/shop_screen.dart';
import '../components/drawer.dart';
import '../models/coffee_model.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  //current user
  final user = FirebaseAuth.instance.currentUser!;

  static List<CoffeeModel> img = [
    CoffeeModel("Latte"),
    CoffeeModel('Espresso'),
    CoffeeModel('Americano'),
    CoffeeModel('Cold Coffee'),
    CoffeeModel('Vietnamese Iced Coffee'),
  ];

  List<CoffeeModel> display_list = List.from(img);

  //search bar function
  void updateList(String s) {
    setState(() {
      display_list = img
          .where((element) =>
              element.coffee_name!.toLowerCase().contains(s.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabSelection);
    super.initState();
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // sign user out method
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  /*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            onPressed: signOut,
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
          child: Text(
        "LOGGED IN AS: " + user.email!,
        style: TextStyle(fontSize: 20),
      )),
    );
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forums'),
        actions: [
          //sign out button
          IconButton(
            onPressed: signOut,
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 15),
          child: ListView(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "It's a Great Day for Coffee",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                width: MediaQuery.of(context).size.width,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),

                //search bar
                child: TextFormField(
                  onChanged: (value) => updateList(value),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Find your coffee",
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 30,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ),

              //filter bar
              /* 
              TabBar(
                  controller: _tabController,
                  labelColor: Color(0xFFE57734),
                  unselectedLabelColor: Colors.white.withOpacity(0.5),
                  isScrollable: true,
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(
                      width: 3,
                      color: Color(0xFFE57734),
                    ),
                    insets: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  labelStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  labelPadding: EdgeInsets.symmetric(horizontal: 20),
                  tabs: [
                    Tab(text: "Hot Coffee"),
                    Tab(text: "Cold Coffee"),
                    Tab(text: "Specialty Coffee"),
                  ]),
              
              TabBarView(
                controller: _tabController,
                children: children), 
              
              */

              const SizedBox(height: 10),

              Center(
                //coffee boxes
                child: [
                  GridView.count(
                    physics: ScrollPhysics(),
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    childAspectRatio: (150 / 195),
                    children: [
                      for (int i = 0; i < display_list.length; i++)
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 13),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color.fromARGB(255, 30, 29, 28),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  spreadRadius: 1,
                                  blurRadius: 9,
                                )
                              ]),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  //americano forum
                                  if (display_list[i].coffee_name ==
                                      'Americano') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AmericanoForum(
                                            coffee_type: display_list[i]),
                                      ),
                                    );
                                    //latte forum
                                  } else if (display_list[i].coffee_name ==
                                      'Latte') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LatteForum(
                                            coffee_type: display_list[i]),
                                      ),
                                    );
                                    //cold coffee forum
                                  } else if (display_list[i].coffee_name ==
                                      'Cold Coffee') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ColdCoffeeForum(
                                            coffee_type: display_list[i]),
                                      ),
                                    );
                                    //espresso forum
                                  } else if (display_list[i].coffee_name ==
                                      'Espresso') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EspressoForum(
                                            coffee_type: display_list[i]),
                                      ),
                                    );
                                    //vietnamese coffee forum
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            VietnameseIceCoffeeForum(
                                                coffee_type: display_list[i]),
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  child: Image.asset(
                                    "lib/images/${display_list[i].coffee_name!}.png",
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 8),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    children: [
                                      Text(
                                        display_list[i].coffee_name!,
                                        style: const TextStyle(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Color(0xFfe57734),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Icon(
                                        CupertinoIcons
                                            .bubble_left_bubble_right_fill,
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
                  ),
                ][_tabController.index],
              )
            ],
          ),
        ),
      ),
    );
  }
}
