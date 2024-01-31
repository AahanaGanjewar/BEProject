import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BestSellingProductsBarChart extends StatefulWidget {
  @override
  _BestSellingProductsBarChartState createState() =>
      _BestSellingProductsBarChartState();
}

class _BestSellingProductsBarChartState
    extends State<BestSellingProductsBarChart> {
  late List<MapEntry<String, dynamic>> bestSellingProducts;
  late DateTime selectedMonth;

  @override
  void initState() {
    super.initState();
    selectedMonth = DateTime.now();
    _fetchBestSellers();
  }

  Future<void> _fetchBestSellers() async {
    DatabaseReference databaseReference = FirebaseDatabase.instance
        .reference()
        .child('Items sold'); // Update with your Firebase path
    DataSnapshot dataSnapshot = await databaseReference.get();

    if (dataSnapshot.value is Map<dynamic, dynamic>) {
      Map<dynamic, dynamic> salesMap =
          dataSnapshot.value as Map<dynamic, dynamic>;

      List<MapEntry<String, dynamic>> entries = [];
      salesMap.forEach((key, value) {
        DateTime date = DateFormat("yyyy-MM-dd").parse(key);
        if (date.month == selectedMonth.month &&
            date.year == selectedMonth.year) {
          value.forEach((product, quantity) {
            int index = entries.indexWhere((element) => element.key == product);
            if (index != -1) {
              entries[index] =
                  MapEntry(product, entries[index].value + quantity);
            } else {
              entries.add(MapEntry(product, quantity));
            }
          });
        }
      });

      entries.sort((a, b) => b.value.compareTo(a.value));
      bestSellingProducts =
          entries.sublist(0, entries.length > 5 ? 5 : entries.length);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50), // Adjust the height as needed
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
          ),
          title: Text(
            "Best Sellers",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                // color: Colors.black,
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: bestSellingProducts != null
            ? _buildBarChart()
            : CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: bestSellingProducts[0].value.toDouble() * 1.2,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,

               

                getTitlesWidget: (value, meta) {
                  if (value < bestSellingProducts.length) {
                    final words =
                        bestSellingProducts[value.toInt()].key.split(' ');
                    return Text(words.join('\n'));
                  }
                  return Text('');
                },
                // getTitlesWidget: (double value, meta) {
                //   return Text(bestSellingProducts[value.toInt()].key);
                // },
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
                // getTextStyles: (value) => const TextStyle(
                //   color: Colors.black,
                //   fontWeight: FontWeight.bold,
                //   fontSize: 14,
                // ),
                getTitlesWidget: (value, meta) {
                  return Text(value.toInt().toString());
                },
              ),
            )),
        gridData: FlGridData(show: false),
        barGroups: List.generate(bestSellingProducts.length, (index) {
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: bestSellingProducts[index].value.toDouble(),
                color: Colors.blue,
                width: 30,
              ),
            ],
            showingTooltipIndicators: [0],
          );
        }),
      ),
    );
  }
}
