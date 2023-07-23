import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kopimate/screens/forum_details.dart';
import 'package:kopimate/screens/shop_home.dart';
import '../models/coffee_model.dart';

class ForumHome extends StatefulWidget {
  const ForumHome({super.key});

  @override
  State<ForumHome> createState() => _ForumHomeState();
}

class _ForumHomeState extends State<ForumHome>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 0;
  late TabController _tabController;

  //current user
  final user = FirebaseAuth.instance.currentUser!;

  static List<CoffeeModel> img = [
    CoffeeModel("Latte"),
    CoffeeModel('Espresso'),
    CoffeeModel('Americano'),
    CoffeeModel('Cold Coffee'),
    CoffeeModel('Viet Iced Coffee'),
  ];

  List<CoffeeModel> displayList = List.from(img);

  //search bar function
  void updateList(String s) {
    setState(() {
      displayList = img
          .where((element) =>
              element.coffeeName!.toLowerCase().contains(s.toLowerCase()))
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

  void goToShops() {
    //pop menu
    Navigator.pop(context);

    //go to shops page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ShopScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forums'),
        actions: [
          //sign out button
          IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 15),
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
                margin:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
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
              const SizedBox(height: 10),
              Center(
                //coffee boxes
                child: [
                  GridView.count(
                    physics: const ScrollPhysics(),
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    childAspectRatio: (150 / 195),
                    children: [
                      for (int i = 0; i < displayList.length; i++)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 13),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color.fromARGB(255, 30, 29, 28),
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ForumDetails(
                                          coffeeType: displayList[i]),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(10),
                                  child: Image.asset(
                                    "lib/images/${displayList[i].coffeeName!}.png",
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    children: [
                                      Text(
                                        displayList[i].coffeeName!,
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFfe57734),
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
