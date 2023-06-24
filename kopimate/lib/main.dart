import 'package:flutter/material.dart';
import 'package:kopimate/screens/auth.dart';
import 'package:kopimate/screens/home.dart';
import 'package:kopimate/screens/shop_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KopiMate',
      theme: ThemeData(
          /* primarySwatch: Colors.brown,
          appBarTheme: const AppBarTheme(
            color: Colors.brown,
          ),*/
          useMaterial3: true),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
        selectedIndex: selectedIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.explore),
            label: 'Nearby',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups),
            label: 'Forum',
          ),
        ],
      ),
      body: <Widget>[
        const ShopScreen(),
        HomePage(),
      ][selectedIndex],
    );
  }
}
