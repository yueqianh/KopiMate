import 'package:flutter/material.dart';
import 'package:kopimate/components/my_list_tile.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onSignOut;
  final void Function()? onShopTap;

  const MyDrawer({super.key, required this.onSignOut, required this.onShopTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        children: [
          //header
          const DrawerHeader(
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 64,
            ),
          ),
        
          //home list tile
          MyListTile(
            icon: Icons.home, 
            text: 'H O M E',
            onTap: () => Navigator.pop(context),
            ),
          
          //profile list tile

          //shops list tile
          MyListTile(
            icon: Icons.storefront, 
            text: 'S H O P S',
            onTap: onShopTap,
            ),

          //logout list tile
          MyListTile(
            icon: Icons.logout, 
            text: 'L O G O U T',
            onTap: onSignOut,
            ),
        ],
      ),
    );
  }
}