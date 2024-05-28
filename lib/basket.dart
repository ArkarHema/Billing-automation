import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bill_automation/SecondPage.dart';
import 'dart:async';

class basket extends StatefulWidget {
  const basket({Key? key}) : super(key: key);

  @override
  State<basket> createState() => _basketState();
}

showDoneDialog(BuildContext context) {
  Widget continueButton = TextButton(
    child: const Text("Ok"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    /*title: const Text(""),*/
    content: const Text("Successful, show the details to the guard"),
    actions: [
      continueButton,
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showPaymentDialog(BuildContext context) {
  Widget continueButton = TextButton(
    child: const Text("Ok"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    /*title: const Text(""),*/
    content: const Text("Verified by the guard, pay the bill"),
    actions: [
      continueButton,
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

// ignore: camel_case_types
class _basketState extends State<basket> {
  String barcodeNo = '';
  String barcodeNo2 = '';
  String productName1 = '';
  int sno1 = 1;
  int price_product1 = 0;
  int weight_product1 = 0;
  int quantity_product1 = 0;
  String productName2 = '';
  int sno2 = 2;
  int price_product2 = 0;
  int weight_product2 = 0;
  int quantity_product2 = 0;
  int total_weight = 0;
  int total_quantity = 0;
  int total_cost = 0;
  final CollectionReference trolley =
      FirebaseFirestore.instance.collection('101');
  @override
  Widget build(BuildContext context) {
    Future<void> fetchData(String barcodeNo, String barcodeNo2) async {
      try {
        print("object");
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('101')
            .doc(barcodeNo)
            .get();
        DocumentSnapshot documentSnapshot2 = await FirebaseFirestore.instance
            .collection('101')
            .doc(barcodeNo2)
            .get();
        if (!documentSnapshot.exists) {
          setState(() {
            productName1 = "black pens";
          });
        } else {
          setState(() {
            productName1 =
                documentSnapshot.get('Product_name') ?? 'Name not found';
            price_product1 = documentSnapshot.get('Price') ?? 'not found';
            weight_product1 = documentSnapshot.get('Weight') ?? 'No';
            quantity_product1 = documentSnapshot.get('Quantity') ?? 'No';
            productName2 =
                documentSnapshot2.get('Product_name') ?? 'Name not found';
            price_product2 = documentSnapshot2.get('Price') ?? 'not found';
            weight_product2 = documentSnapshot2.get('Weight') ?? 'No';
            quantity_product2 = documentSnapshot2.get('Quantity') ?? 'No';
            total_quantity = quantity_product1 + quantity_product2;
            total_weight = weight_product1 + weight_product2;
            total_cost = price_product1 + price_product2;
            print(total_weight);
          });
        }
      } catch (e) {
        setState(() {
          productName1 = 'Failed to fetch document';
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bill"),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const <Widget>[
                      Text("S.NO"),
                      Text("Name of the product"),
                      Text("Price"),
                      Text("Weight"),
                      Text("Quantity"),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text('$sno1'),
                      Text('$productName1\n'),
                      Text('$price_product1'),
                      Text('$weight_product1'),
                      Text('$quantity_product1'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text('$sno2'),
                      Text('$productName2\n'),
                      Text('$price_product2'),
                      Text('$weight_product2'),
                      Text('$quantity_product2'),
                    ],
                  ),
                  const SizedBox(height: 36.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: <Widget>[
                          Text("Total weight: $total_weight"),
                          const SizedBox(
                            height: 16.0,
                          ),
                          Text("Total Quantity: $total_quantity"),
                          const SizedBox(
                            height: 16.0,
                          ),
                          Text("Total cost: $total_cost"),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              ElevatedButton(
                  onPressed: () {
                    // showDoneDialog(context);
                    fetchData('8901030708114', '8901138504519');
                  },
                  child: const Text('Validate bill')),
              ElevatedButton(
                  onPressed: () {
                    showPaymentDialog(context);
                  },
                  child: const Text('Payment'))
            ]),
      ),
    );
  }
}
