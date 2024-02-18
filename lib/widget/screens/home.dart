// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:restaurant_owner_app/widget/screens/salepred.dart';
import 'inventory_page.dart';
import 'sales.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // void changeTab(int index) {
  //   setState(() => _currentIndex = index);
  // }

  final _screens = [
    SalesPage(),
    InventoryPage(),
    SalePred()
  ];

   @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Color(0xffF3F8FF),
    bottomNavigationBar: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.white,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Color(0xff49108B),
              color: Color(0xff7E30E1),
              tabs: [
                GButton(
                  icon: Icons.home,
                  text: 'Dashboard',
                ),
                GButton(
                  icon: Icons.inventory,
                  text: 'Inventory',
                ),
                GButton(
                  icon: Icons.price_change,
                  text: 'Sales',
                ),
                
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                  print(_selectedIndex);
                });
              },
            ),
          ),
        ),
      ),
    ),
    body: 
     _selectedIndex < _screens.length ? _screens[_selectedIndex] : Container(),

  );
}

}