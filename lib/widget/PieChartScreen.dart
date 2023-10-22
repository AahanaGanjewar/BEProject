import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';

class PieChartScreen extends StatefulWidget {
  @override
  _PieChartScreenState createState() => _PieChartScreenState();
}

class _PieChartScreenState extends State<PieChartScreen> {
  Map<String, dynamic>? salesData;

  @override
  void initState() {
    super.initState();
    _fetchSalesData();
  }

  Future<void> _fetchSalesData() async {
    DatabaseReference databaseReference = FirebaseDatabase.instance
        .reference()
        .child('Category sold'); // Replace with your actual Firebase path

    DataSnapshot dataSnapshot =
        await databaseReference.child('2023-10-20').get();

    if (dataSnapshot.value != null) {
      Map<dynamic, dynamic> data = dataSnapshot.value as Map<dynamic, dynamic>;
      setState(() {
        salesData = Map<String, dynamic>.from(data);
      });
    }
  }

  List<PieChartSectionData> generatePieChartSections() {
    if (salesData == null) {
      return [];
    }

    int total =
        salesData!.values.fold(0, (sum, element) => sum + (element as int));

    return salesData!.entries.map((entry) {
      double value = (entry.value as int) / total;
      return PieChartSectionData(
        value: value,
        title: '${entry.key} - ${(value * 100).toStringAsFixed(2)}%',
        color: Color((entry.key.hashCode * 0xFFFFFF).toInt()).withOpacity(1.0),
        radius: 100,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales Distribution'),
      ),
      body: Center(
        child: salesData == null
            ? CircularProgressIndicator()
            : SizedBox(
                width: 300,
                height: 300,
                child: PieChart(
                  PieChartData(
                    sections: generatePieChartSections(),
                  ),
                ),
              ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(
      home: PieChartScreen(),
    ));
