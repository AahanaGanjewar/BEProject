// ignore_for_file: prefer_const_constructors

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_owner_app/firebase/firebaseData.dart';
import 'package:restaurant_owner_app/model/SalesData.dart';
import 'package:intl/intl.dart';

class SalesChartScreen extends StatefulWidget {
  @override
  _SalesChartScreenState createState() => _SalesChartScreenState();
}

class _SalesChartScreenState extends State<SalesChartScreen> {
  List<SalesData> salesDataList = [];
  DateTime selectedMonth = DateTime.now();

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

  void _changeMonth(int monthsToAdd) {
    setState(() {
      selectedMonth = DateTime(
        selectedMonth.year,
        selectedMonth.month + monthsToAdd,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: Color(0xff7E30E1),
        elevation: 0,
        centerTitle: true,
        
        title: Text(
          "Monthly Sales",
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Month headline
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              DateFormat('MMMM yyyy').format(selectedMonth),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Chart
          Expanded(
            child: Center(
              child: salesDataList.isEmpty
                  ? CircularProgressIndicator()
                  : _buildChart(),
            ),
          ),
          // Navigation buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.purple,),
                onPressed: () {
                  _changeMonth(-1); // Go to previous month
                  _fetchSalesData();
                },
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward, color: Colors.purple,),
                onPressed: () {
                  _changeMonth(1); // Go to next month
                  _fetchSalesData();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    // Construct your chart here using the data in salesDataList
    // Filter sales data for the selected month
    List<SalesData> filteredData = salesDataList.where((data) {
      // Convert the Firebase date string to DateTime
      DateTime date = DateFormat("yyyy-MM-dd").parse(data.date);
      // Check if the data falls within the selected month
      return date.month == selectedMonth.month &&
          date.year == selectedMonth.year;
    }).toList();
    return Container(
      height: 1000,
      child: LineChart(
        LineChartData(
          backgroundColor: Colors.white,
          gridData: FlGridData(show: false),
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: Colors.grey, // Adjust the border color
              width: 1, // Adjust the border width
            ),
          ),
          titlesData: FlTitlesData(
              show: true,
              // leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 20, interval: 100)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    // Convert the value to an integer and use it as an index to fetch the date
                    final index = value.toInt();

                    // Check if the index is within the bounds of your data
                    if (index >= 0 && index < salesDataList.length) {
                      // Assuming your SalesData has a 'date' field of type String
                      final dateString = salesDataList[index].date;
                      // Parse the string to a DateTime object
                      final date = DateTime.parse(dateString);
                      // Format the date as needed
                      return Text(DateFormat('dd').format(date));
                    }

                    return Text(
                        ''); // Return an empty string for invalid indices
                  },
                ),
              )),
          // Configure your chart based on salesDataList
          // Example: Add sales data from salesDataList to spots in LineChartBarData
          lineBarsData: [
            LineChartBarData(
              spots: filteredData.asMap().entries.map((entry) {
                return FlSpot(entry.key.toDouble(), entry.value.amount);
              }).toList(),
              isCurved: true,
              color: Color(0xffE26EE5),
            ),
          ],
          // Configure other chart properties as needed
        ),
      ),
    );
  }
}
