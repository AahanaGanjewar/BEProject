// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_owner_app/widget/PieChartScreen.dart';
import 'package:restaurant_owner_app/widget/SalesChartScreen.dart';
import 'package:restaurant_owner_app/widget/TodaySale.dart';
import 'package:restaurant_owner_app/widget/screens/reviews.dart';
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
      backgroundColor: Color(0xffF3F8FF),
      appBar: AppBar(
        backgroundColor: Color(0xff49108B),
        elevation: 0,
        centerTitle: true,
        
        title: Text(
          "City Sales",
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              icon: Icon(
                Icons.sms,
                color: Color(0xffF3F8FF),
                size: 35,
              ),
              onPressed: () {
                // Add your notification button functionality here
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ReviewScreen()));
              },
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(color: Color(0xffF3F8FF)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  // ignore: prefer_const_constructors
                  side: BorderSide(
                    color: Color(0xff49108B),
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
                  height: 700,
                  child: Card(
                    elevation: 5,
              
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
                   
                    child: Center(child: BestSellingProductsBarChart()),
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
                    ),
                    child: Center(child: PieChartScreen()),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
