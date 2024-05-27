// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class ArimaPage extends StatefulWidget {
  @override
  ArimaPageState createState() => ArimaPageState();
}

class ArimaPageState extends State<ArimaPage> {
  List<dynamic> forecastData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:5000/api/forecast'));
    if (response.statusCode == 200) {
      setState(() {
        forecastData = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load forecast data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF3F8FF),
      appBar: AppBar(
        // centerTitle: true,
        backgroundColor: Color(0xff49108B),
        elevation: 0,
        title: Text(
          "Inventory Forecast",
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          String predictionString = forecastData[index]['Predicted Consumption'].toString();
    
    double predictionValue;
    try {
      predictionValue = double.parse(predictionString);
    } catch (e) {
      // Handle the error, for example, set a default value or log a message
      predictionValue = 0.0;
    }

    int roundedValue = predictionValue.ceil();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                      forecastData[index]['Item'],
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff7E30E1),
                        ),
                      ),
                    ),
                    Text(
                      roundedValue.toString()+" unit",
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
        itemCount: forecastData.length,
      ),
    );
  }
}
