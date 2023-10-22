import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'inventory_page.dart';
import 'sales.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  void changeTab(int index) {
    setState(() => _currentIndex = index);
  }

  final screens = [
    SalesPage(),
    InventoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,

        // onTap: (index) {
        //   if (index == 1) {
        //     // Navigate to the InventoryPage when the "Inventory" tab is clicked
        //     Navigator.push(context, MaterialPageRoute(builder: (context) => InventoryPage()));
        //   } else {
        //     setState(() {
        //       _currentIndex = index;
        //     });
        //   }
        // },
        onTap: (index) => changeTab(index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Sales',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storage),
            label: 'Inventory',
          ),
        ],
      ),
    );
  }
}
