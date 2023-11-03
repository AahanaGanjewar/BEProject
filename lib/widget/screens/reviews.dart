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
    print(data.toString());
    print("******************");
    setState(() {
      happyPercentage = data['percentage_happy_reviews'];
      print(happyPercentage);
      print("-----------------");
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
                  child: Icon(
                    Icons.sentiment_satisfied,
                    size: 100,
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
                  child: Icon(
                    Icons.sentiment_very_dissatisfied,
                    size: 100,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Happy Reviews: ${happyPercentage.toStringAsFixed(2)}%',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Not Happy Reviews: ${notHappyPercentage.toStringAsFixed(2)}%',
              style: TextStyle(fontSize: 20),
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
                return ListTile(
                  title: Text(data['happy_reviews'][index]),
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
                return ListTile(
                  title: Text(data['not_happy_reviews'][index]),
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
