// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Review App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ReviewScreen(),
    );
  }
}

class ReviewScreen extends StatefulWidget {
  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  double happyPercentage = 80.0;
  double notHappyPercentage = 20.0;

  Future<void> fetchHappyPercentage() async {
    final response = await http
        .get(Uri.parse('http://127.0.0.1:5000/api/percentage_happy_reviews'));
    final data = json.decode(response.body);
    setState(() {
      happyPercentage = data['percentage_happy_reviews'];
    });
  }

  Future<void> fetchNotHappyPercentage() async {
    final response = await http.get(
        Uri.parse('http://127.0.0.1:5000/api/percentage_not_happy_reviews'));
    final data = json.decode(response.body);
    setState(() {
      notHappyPercentage = data['percentage_not_happy_reviews'];
    });
  }

  @override
  void initState() {
    super.initState();
    fetchHappyPercentage();
    fetchNotHappyPercentage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF3F8FF),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xff49108B),
          elevation: 0,
          
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Reviews",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              // SizedBox(width: 16), // Add spacing between title and dropdown
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    margin: EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: 600, // Adjust width as needed
                        height: 600, // Adjust height as needed
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReviewsMenuScreen(),
                              ),
                            );
                          },
                          child: PieChart(
                            PieChartData(
                              sections: [
                                PieChartSectionData(
                                  color: Colors.green,
                                  value: happyPercentage,
                                  title: 'Satisfied',
                                  radius: 100,
                                  titleStyle: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                PieChartSectionData(
                                  color: Colors.red,
                                  value: notHappyPercentage,
                                  title: 'Dissatisfied',
                                  radius: 100,
                                  titleStyle: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 200,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Satisfied',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '${happyPercentage.toString()}%',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green[600],
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Dissatisfied',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '${notHappyPercentage.toString()}%',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class ReviewsMenuScreen extends StatefulWidget {
  @override
  State<ReviewsMenuScreen> createState() => _ReviewsMenuScreenState();
}

class _ReviewsMenuScreenState extends State<ReviewsMenuScreen> {
  int _selectedIndex = 0;

  // void changeTab(int index) {
  //   setState(() => _currentIndex = index);
  // }

  final _screens = [
    HappyReviewsScreen(),
    NotHappyReviewsScreen(),
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
                  icon: Icons.sentiment_satisfied,
                  text: 'Satisfied',
                ),
                GButton(
                  icon: Icons.sentiment_dissatisfied,
                  text: 'Not Satisfied',
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

class HappyReviewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff49108B),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Color(0xff49108B),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Happy Reviews",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            // SizedBox(width: 16), // Add spacing between title and dropdown
          ],
        ),
      ),
      body: FutureBuilder<http.Response>(
        future: http.get(Uri.parse('http://127.0.0.1:5000/api/happy_reviews')),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = json.decode(snapshot.data!.body);
            return ListView.builder(
              itemCount: data['happy_reviews'].length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[200],
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(data['happy_reviews'][index]),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching data'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class NotHappyReviewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff49108B),
        elevation: 0,
        
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Not Happy Reviews",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            // SizedBox(width: 16), // Add spacing between title and dropdown
          ],
        ),
      ),
      body: FutureBuilder<http.Response>(
        future:
            http.get(Uri.parse('http://127.0.0.1:5000/api/not_happy_reviews')),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = json.decode(snapshot.data!.body);
            return ListView.builder(
              itemCount: data['not_happy_reviews'].length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[200],
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(data['not_happy_reviews'][index]),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching data'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
