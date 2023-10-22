import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_owner_app/widget/BestSellerBarChart.dart';
import 'package:restaurant_owner_app/widget/PieChartScreen.dart';
import 'package:restaurant_owner_app/widget/SalesChartScreen.dart';
import 'package:restaurant_owner_app/widget/TodaySale.dart';
import 'package:restaurant_owner_app/widget/screens/home.dart';
import 'package:restaurant_owner_app/widget/screens/sales.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant Owner App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PieChartScreen(),
      //BestSellerPieChartScreen(), // Use your SalesChartScreen as the main widget
    );
  }
}
