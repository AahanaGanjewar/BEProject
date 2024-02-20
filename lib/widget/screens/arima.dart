// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';

class ArimaPage extends StatefulWidget {
  @override
  ArimaPageState createState() => ArimaPageState();
}

class ArimaPageState extends State<ArimaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF3F8FF),
      appBar: AppBar(
        // centerTitle: true,
        backgroundColor: Color(0xff49108B),
        elevation: 0,
        title: Text(
          "ARIMA",
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
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              height: 80,
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    // color: Colors.blue.shade200,
                    color: Colors.grey.shade50,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Product",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff7E30E1),
                          ),
                        )),
                    Text("data",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff7E30E1),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: 10,
      ),
    );
  }
}
