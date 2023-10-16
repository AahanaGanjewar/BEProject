import 'package:firebase_database/firebase_database.dart';
import '../model/SalesData.dart';

Future<List<SalesData>> fetchSalesData() async {
  List<SalesData> salesDataList = [];

  try {
    DatabaseReference databaseReference = FirebaseDatabase.instance
        .reference()
        .child('Sales'); // Replace with your actual Firebase path

    DataSnapshot dataSnapshot = await databaseReference.get();

    // Check if dataSnapshot.value is not null and is of type Map<dynamic, dynamic>
    if (dataSnapshot.value is Map<dynamic, dynamic>) {
      Map<dynamic, dynamic> salesMap =
          dataSnapshot.value as Map<dynamic, dynamic>;

      salesMap.forEach((key, value) {
        salesDataList.add(SalesData(key, double.parse(value.toString())));
      });
    } else {
      print('Data not found in the database');
    }
  } catch (error) {
    print('Error fetching sales data: $error');
  }
  print('karan $salesDataList');
  return salesDataList;
}
