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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(72),
        child: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent,
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
                Container(
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
                              //               getTitlesWidget: (value, meta) {
                              //   if (value < bestSellingProducts.length) {
                              //     final words =
                              //         bestSellingProducts[value.toInt()].key.split(' ');
                              //     return Text(words.join('\n'));
                              //   }
                              //   return Text('');
                              // },
                            )),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  return Text(value.toInt().toString());
                                },
                              ),
                            ))),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: weeklySalesList.length,
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
                        child: Text(
                            "${weeklySalesList[index]['date']} - ${weeklySalesList[index]['prediction']}"),
                      );
                    },
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
            color: Colors.blue,
          ),
        ],
      );
    });
  }
}
