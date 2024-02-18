import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class PieChartScreen extends StatefulWidget {
  @override
  _PieChartScreenState createState() => _PieChartScreenState();
}

class _PieChartScreenState extends State<PieChartScreen> {
  final databaseReference =
      FirebaseDatabase.instance.reference().child('Category sold');

  Map<String, dynamic> data = {};

  String dropdownValue = 'Daily';
  String selectedDate = DateTime.now().toString().substring(0, 10);

  void fetchData(String date, String filter) async {
    var event;
    if (filter == 'Weekly') {
      DateTime now = DateTime.now();
      DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      DateTime endOfWeek =
          now.add(Duration(days: DateTime.daysPerWeek - now.weekday));
      String formattedStartOfWeek =
          DateFormat('yyyy-MM-dd').format(startOfWeek);
      String formattedEndOfWeek = DateFormat('yyyy-MM-dd').format(endOfWeek);
      event = await databaseReference
          .orderByKey()
          .startAt(formattedStartOfWeek)
          .endAt(formattedEndOfWeek)
          .once();
    } else if (filter == 'Monthly') {
      String firstDayOfMonth =
          DateFormat('yyyy-MM-01').format(DateTime.parse(date));
      String lastDayOfMonth = DateFormat('yyyy-MM-')
          .format(DateTime.parse(date).add(Duration(days: 32)))
          .substring(0, 8);
      event = await databaseReference
          .orderByKey()
          .startAt(firstDayOfMonth)
          .endAt(lastDayOfMonth)
          .once();
    } else {
      event = await databaseReference.child(date).once();
    }

    if (event.snapshot.value != null) {
      Object? fetchedData = event.snapshot.value;
      if (fetchedData is Map) {
        setState(() {
          data = Map<String, dynamic>.from(fetchedData);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData(selectedDate, dropdownValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff7E30E1),
        elevation: 0,
        centerTitle: true,
        
        title: Text(
          "Pie Chart",
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DropdownButton<String>(
            value: dropdownValue,
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
                if (newValue == 'Daily') {
                  selectedDate = DateTime.now().toString().substring(0, 10);
                } else if (newValue == 'Weekly') {
                  selectedDate = DateTime.now().toString().substring(0, 10);
                } else if (newValue == 'Monthly') {
                  selectedDate = DateTime.now().toString().substring(0, 7);
                }
                fetchData(selectedDate, newValue);
              });
            },
            items: <String>['Daily', 'Weekly', 'Monthly']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          data.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: PieChart(
                    
                      PieChartData(
                      
                        sections: getSections(),
                        sectionsSpace: 0,
                        centerSpaceRadius: 50,
                        //showingLegends: true,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  List<PieChartSectionData> getSections() {
    List<PieChartSectionData> sections = [];
    int index = 0;
    data.forEach((key, value) {
      if (value != null) {
        sections.add(
          PieChartSectionData(
            value: value is int ? value.toDouble() : 0.0,
            title: '$key\n$value',
            color: getColor(index),
            radius: 100,
          ),
        );
      }
      index++;
    });
    return sections;
  }

  Color getColor(int index) {
    List<Color> colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
    ];
    return colors[index % colors.length];
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: PieChartScreen(),
//   ));
// }
