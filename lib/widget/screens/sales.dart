// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_owner_app/widget/PieChartScreen.dart';
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50), // Adjust the height as needed
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
          ),
          title: Text(
            "City Sales",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications, color: Colors.black),
              onPressed: () {
                // Add your notification button functionality here
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 800,
                  child: Card(
                    elevation: 5,
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(10),
                    //   side: BorderSide(
                    //     color: Colors.green,
                    //     width: 2,
                    //   ),
                    // ),
                    child: Center(child: SalesChartScreen()),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 700,
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      // side: BorderSide(
                      //   color: Colors.green,
                      //   width: 2,
                      // ),
                    ),
                    child: Center(child: BestSellingProductsBarChart()),
                    // child: Padding(
                    //   padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),

                    // ),
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
                  child: Center(child: PieChartScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
