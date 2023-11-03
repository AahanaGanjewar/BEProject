import 'package:flutter/material.dart';
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
  double happyPercentage = 0.0;
  double notHappyPercentage = 0.0;

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
      appBar: AppBar(
        title: Text('Reviews'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HappyReviewsScreen()),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/good.png', // Replace with your asset image path
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotHappyReviewsScreen()),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/bad.png', // Replace with your asset image path
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Happy Reviews',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'Not Happy Reviews',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  '${happyPercentage.toStringAsFixed(2)}%',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  '${notHappyPercentage.toStringAsFixed(2)}%',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HappyReviewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Happy Reviews'),
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
        title: Text('Not Happy Reviews'),
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
