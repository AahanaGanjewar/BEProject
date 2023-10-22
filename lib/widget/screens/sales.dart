// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:restaurant_owner_app/widget/SalesChartScreen.dart';
import 'package:restaurant_owner_app/widget/TodaySale.dart';
import '../BestSellerBarChart.dart';
import 'inventory_page.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({Key? key}) : super(key: key);

  @override
  SalesPageState createState() => SalesPageState();
}

class SalesPageState extends State<SalesPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              // Add your notification button functionality here
            },
          ),
        ],
        title: Text("Hi Karan"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                // ignore: prefer_const_constructors
                side: BorderSide(
                  color: Colors.blue,
                  width: 2,
                ),
              ),
              child: Container(
                  height: 170,
                  alignment: Alignment.center,
                  // ignore: prefer_const_constructors
                  child: TodaysSaleComparisonScreen()),
            ),
            Container(
              height: 700,
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: Colors.green,
                    width: 2,
                  ),
                ),
                child: Center(child: SalesChartScreen()),
              ),
            ),
            Container(
              height: 700,
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: Colors.green,
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
                  child: Center(child: BestSellingProductsBarChart()),
                ),
              ),
            ),
            Container(
              height: 700,
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: Colors.orange,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    "Container 3",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
