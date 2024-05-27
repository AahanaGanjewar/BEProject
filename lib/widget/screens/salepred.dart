// ignore_for_file: prefer_const_constructors

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SalePred extends StatefulWidget {
  const SalePred({Key? key}) : super(key: key);

  @override
  State<SalePred> createState() => _SalePredState();
}

class _SalePredState extends State<SalePred> {
  late List<Map<String, dynamic>> weeklySalesList;

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
              "Sales Prediction",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<http.Response>(
        future:
            http.get(Uri.parse('http://127.0.0.1:5000/api/weeklysaleslist')),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = json.decode(snapshot.data!.body);
            weeklySalesList =
                List<Map<String, dynamic>>.from(data['weekly_sales_list']);

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Container(
                    height: 300,
                    child: BarChart(
                      BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: getMaxPrediction(), // Set your custom max value
                          barGroups: getBarGroups(),
                          titlesData: FlTitlesData(
                              show: true,
                              rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                        // Define a list of days starting from Sunday (index 0)
                        List<String> daysOfWeek = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
                        
                        // Ensure the value is a valid index within the list
                        if (value >= 0 && value < daysOfWeek.length) {
                          return Text(daysOfWeek[value.toInt()]);
                        }
                        return Text('');
                      },
                              )),
                              // leftTitles: AxisTitles(
                              //   sideTitles: SideTitles(
                              //     showTitles: true,
                              //     getTitlesWidget: (value, meta) {
                              //       return Text(value.toInt().toString());
                              //     },
                              //   ),
                              // )
                              )),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      String predictionString = weeklySalesList[index]['prediction'].toString();
    
    double predictionValue;
    try {
      predictionValue = double.parse(predictionString);
    } catch (e) {
      // Handle the error, for example, set a default value or log a message
      predictionValue = 0.0;
    }

    int roundedValue = predictionValue.ceil();
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Container(
                          height: 80,
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: Colors.grey.shade50,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  weeklySalesList[index]['date'],
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff7E30E1),
                                    ),
                                  ),
                                ),
                                Text  (
                                  "₹ "+roundedValue.toString()
                                      ,
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff7E30E1),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: weeklySalesList.length,
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching data'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  double getMaxPrediction() {
    double maxPrediction = 0;
    for (var sale in weeklySalesList) {
      if (sale['prediction'] > maxPrediction) {
        maxPrediction = sale['prediction'];
      }
    }
    return maxPrediction;
  }

  List<BarChartGroupData> getBarGroups() {
    return List.generate(weeklySalesList.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: weeklySalesList[index]['prediction'].toDouble(),
            color: Color(0xffE26EE5),
          ),
        ],
      );
    });
  }
}
