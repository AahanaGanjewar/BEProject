import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:restaurant_owner_app/firebase/firebaseData.dart';
import 'package:restaurant_owner_app/model/SalesData.dart';
import 'package:intl/intl.dart';

class SalesChartScreen extends StatefulWidget {
  @override
  _SalesChartScreenState createState() => _SalesChartScreenState();
}

class _SalesChartScreenState extends State<SalesChartScreen> {
  List<SalesData> salesDataList = [];

  @override
  void initState() {
    super.initState();
    _fetchSalesData();
  }

  Future<void> _fetchSalesData() async {
    try {
      final data = await fetchSalesData();

      setState(() {
        salesDataList = data;
      });
    } catch (error) {
      // Handle errors
      print('Error fetching sales data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales Chart'),
      ),
      body: Center(
        child: salesDataList.isEmpty
            ? CircularProgressIndicator() // Display a loading indicator while data is being fetched
            : _buildChart(),
      ),
    );
  }

  Widget _buildChart() {
    // Construct your chart here using the data in salesDataList
    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(
            show: true,
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  // Convert the value to an integer and use it as an index to fetch the date
                  final index = value.toInt();

                  // Check if the index is within the bounds of your data
                  if (index >= 0 && index < salesDataList.length) {
                    // Assuming your SalesData has a 'date' field of type DateTime
                    final date = salesDataList[index].date;
                    // Format the date as needed, e.g., using the intl package
                    //return DateFormat('MMM dd').format(date as DateTime);
                    print("karan " + date);
                    return Text(date);
                  }

                  //return ''; // Return an empty string for invalid indices
                  return Text('');
                },
              ),
            )),
        // Configure your chart based on salesDataList
        // Example: Add sales data from salesDataList to spots in LineChartBarData
        lineBarsData: [
          LineChartBarData(
            spots: salesDataList.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(), entry.value.amount);
            }).toList(),
            isCurved: true,
            color: Colors.blue,
          ),
        ],
        // Configure other chart properties as needed
      ),
    );
  }
}
