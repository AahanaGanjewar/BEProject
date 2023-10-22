import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class TodaysSaleComparisonScreen extends StatefulWidget {
  @override
  _TodaysSaleComparisonScreenState createState() =>
      _TodaysSaleComparisonScreenState();
}

class _TodaysSaleComparisonScreenState
    extends State<TodaysSaleComparisonScreen> {
  late int todaySale;
  late int lastWeekdaySale;

  @override
  void initState() {
    super.initState();
    _fetchSalesData();
  }

  Future<void> _fetchSalesData() async {
    DatabaseReference databaseReference = FirebaseDatabase.instance
        .reference()
        .child('Sales'); // Replace with your actual Firebase path

    DateTime now = DateTime.now();
    int todayWeekday = now.weekday;
    DateTime lastWeekday = now.subtract(Duration(days: todayWeekday));

    // Fetch today's sales
    DataSnapshot todaySnapshot =
        await databaseReference.child(_formatDate(now)).get();
    if (todaySnapshot.value != null) {
      todaySale = int.parse(todaySnapshot.value.toString());
    }

    // Fetch last weekday's sales
    DataSnapshot lastWeekdaySnapshot =
        await databaseReference.child(_formatDate(lastWeekday)).get();
    if (lastWeekdaySnapshot.value != null) {
      lastWeekdaySale = int.parse(lastWeekdaySnapshot.value.toString());
    }

    // Update the UI
    setState(() {});
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: todaySale != null && lastWeekdaySale != null
            ? _buildComparisonCard()
            : CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildComparisonCard() {
    double growthRate = ((todaySale - lastWeekdaySale) / lastWeekdaySale) * 100;

    bool isGrowth = todaySale > lastWeekdaySale;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: isGrowth ? Colors.lightGreen[50] : Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Today\'s Sale: $todaySale',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isGrowth ? Colors.green : Colors.red,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Last Weekday\'s Sale: $lastWeekdaySale',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isGrowth ? Icons.trending_up : Icons.trending_down,
                  color: isGrowth ? Colors.green : Colors.red,
                  size: 30,
                ),
                Text(
                  'Growth Rate: ${growthRate.toStringAsFixed(2)}%',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isGrowth ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
