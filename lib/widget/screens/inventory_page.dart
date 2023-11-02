// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';

class InventoryPage extends StatefulWidget {
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final DatabaseReference _database =
      FirebaseDatabase.instance.reference().child('Inventory used');
  String selectedDate = '2023-11-02'; // Default selected date
  List<String> availableDates = [];
  Map<String, dynamic> inventoryData = {};
  double totalValue = 0;

  @override
  void initState() {
    super.initState();
    _fetchAvailableDates();
    _loadInventoryData(selectedDate);
  }

  Future<void> _fetchAvailableDates() async {
    DataSnapshot snapshot = await _database.get();
    if (snapshot.value is Map<dynamic, dynamic>) {
      Map<dynamic, dynamic> inventoryMap =
          snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        availableDates = inventoryMap.keys.cast<String>().toList();
        availableDates.sort();
      });
    }
  }

  Future<void> _loadInventoryData(String date) async {
    DataSnapshot snapshot = await _database.child(date).get();
    if (snapshot.value is Map<dynamic, dynamic>) {
      Map<dynamic, dynamic> inventoryMap =
          snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        inventoryData = Map<String, dynamic>.from(inventoryMap);
      });
    } else {
      setState(() {
        inventoryData = {};
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    totalValue = 0.0;
    inventoryData.forEach((itemName, itemCount) {
      if (itemName.toLowerCase() == "bread") {
        // Divide by 18 if it's bread
        itemCount = itemCount / 18;
      } else {
        // Divide by 1000 for other items
        itemCount = itemCount / 1000;
      }
      totalValue += itemCount;
    });
    print(totalValue);
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
                "Inventory used",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              // SizedBox(width: 16), // Add spacing between title and dropdown
              DropdownButton<String>(
                value: selectedDate,
                dropdownColor: Colors.deepPurpleAccent[100],
                items: availableDates.map((String date) {
                  return DropdownMenuItem<String>(
                    value: date,
                    child: Text(
                      date,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedDate = newValue;
                      _loadInventoryData(selectedDate);
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              // margin: EdgeInsets.all(16),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Total Unit: ${totalValue.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: inventoryData.isEmpty
                  ? Text("No inventory data available for $selectedDate")
                  : ListView.builder(
                      itemCount: inventoryData.length,
                      itemBuilder: (context, index) {
                        var itemName = inventoryData.keys.elementAt(index);

                        var itemCount = inventoryData[itemName];
                        itemName =
                            itemName[0].toUpperCase() + itemName.substring(1);

                        return Container(
                          padding: EdgeInsets.all(8),
                          height: 150, // Set the height as per your preference
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Card(
                              elevation: 5,
                              // margin: EdgeInsets.all(10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  // color: Colors.blue.shade200,
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      itemName,
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '$itemCount',
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.purple,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            CircularProgressIndicator(
                                              value: itemCount / 10000,
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                      Color.fromARGB(
                                                          255, 204, 39, 30)),
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 240, 165, 253),
                                            ),
                                            Text(
                                              '${(itemCount / 10000 * 100).toInt()}%',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
