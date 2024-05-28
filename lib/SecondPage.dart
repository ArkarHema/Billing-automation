// import 'package:bill_automation/basket.dart';
import 'package:bill_automation/basket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'dart:async';

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  State<SecondPage> createState() => SecondPageState();
}

class SecondPageState extends State<SecondPage> {
  // ignore: non_constant_identifier_names
  String Barcode_no = '';
  String productName = '';
  String barcodeScanRes = '';
  String productData = '';
  int price = 0;
  int weight = 0;
  int p = 5;
  int w = 15;
  int quantity = 1;
  // String ba = '8904155972644';
  String number = '101';
  //
  // void removeField() async {
  //   DocumentReference docRef =
  //       FirebaseFirestore.instance.collection('101').doc(Barcode_no);
  //   await docRef.update({
  //     'myField': FieldValue.delete(),
  //   });
  // }

  Future<void> deleteProduct() {
    return _reference
        .doc(Barcode_no)
        .delete()
        .then((value) => print("Product Deleted"))
        .catchError((error) => print("Failed to delete product: $error"));
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.DEFAULT);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      Barcode_no = barcodeScanRes;
    });
  }

  showAlertDialog(BuildContext context) {
    Widget addButton = TextButton(
      child: const Text("Add"),
      onPressed: () {
        if (Barcode_no != "") {
          try {
            setState(() {
              p = price;
              quantity = 1;
              w = weight;
            });
            FirebaseFirestore.instance.collection(number).doc(Barcode_no).set({
              "Barcode_no": Barcode_no,
              "Product_name": productData,
              "Price": p,
              "Quantity": quantity,
              "Weight": w,
            });
          } catch (e) {
            print(e);
          }
          Navigator.of(context).pop();
        }
      },
    );
    Widget addAgainButton = TextButton(
      child: const Text("Add Again"),
      onPressed: () {
        setState(() {
          p = p + price;
          quantity = quantity + 1;
          w = w + weight;
        });
        if (Barcode_no != "") {
          try {
            FirebaseFirestore.instance
                .collection(number)
                .doc(Barcode_no)
                .update({
              "Product_name": productData,
              "Price": p,
              "Quantity": quantity,
              "Weight": w,
            });
          } catch (e) {
            print(e);
          }
          Navigator.of(context).pop();
        }
      },
    );
    Widget removeOneButton = TextButton(
      child: const Text("Remove one"),
      onPressed: () {
        setState(() {
          p = p - price;
          quantity = quantity - 1;
          w = w - weight;
        });
        if (Barcode_no != "") {
          try {
            FirebaseFirestore.instance
                .collection(number)
                .doc(Barcode_no)
                .update({
              "Product_name": productData,
              "Price": p,
              "Quantity": quantity,
              "Weight": w,
            });
          } catch (e) {
            print(e);
          }
          Navigator.of(context).pop();
        }
      },
    );
    Widget removeButton = TextButton(
      child: const Text('remove'),
      onPressed: () {
        deleteProduct();
        Navigator.of(context).pop();
      },
    );
    Widget billButton = TextButton(
      child: const Text("Bill"),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const basket()));
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      /*title: const Text(""),*/
      title: const Text('Add or Remove'),
      content: const Text('Do you want to add or remove it from the bill'),
      actions: [
        addButton,
        addAgainButton,
        removeButton,
        removeOneButton,
        billButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlert(BuildContext context) {
    Widget okButton = TextButton(
      child: const Text("Ok"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
        /*title: const Text(""),*/
        title: const Text('Scan the product'),
        content: const Text('Scan the product and then add to cart'),
        actions: [
          okButton,
        ]);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // showData(BuildContext context) {
  //   Widget okButton = TextButton(
  //     child: const Text("Ok"),
  //     onPressed: () {
  //       Navigator.of(context).pop();
  //     },
  //   );
  //
  //   // set up the AlertDialog
  //   AlertDialog alert =
  //       AlertDialog(content: const Text('Unibic wafers'), actions: [
  //     okButton,
  //   ]);
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }

  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('101');

  @override
  Widget build(BuildContext context) {
    Future<void> fetchProductData() async {
      try {
        print("object");
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('products_available')
            .doc(Barcode_no)
            .get();
        if (!documentSnapshot.exists) {
          setState(() {
            productData = "black pens";
          });
        } else {
          setState(() {
            productData =
                documentSnapshot.get('Name_of_prod') ?? 'Name not found';
            price = documentSnapshot.get('Price') ?? 'not found';
            print(price);
            weight = documentSnapshot.get('Weight') ?? 'No';
            print(weight);
          });
        }
      } catch (e) {
        setState(() {
          productData = 'black pens';
        });
      }
    }

    final users = FirebaseFirestore.instance
        .collection('products_available')
        .doc('8904155972644');
    Future<void> addUser() async {
      final data = {
        'Name_of_prod': 'Totem pen',
        'Price': 5,
        'Barcode_no': '8904155972644',
        'Weight': 8.1
      };
      await users.set(data);
    }

//8901207040795  8901030708114
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan"),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              OutlinedButton(
                  onPressed: () {
                    scanBarcodeNormal();
                  },
                  child: const Text('Start barcode scan')),
              Text('Scan result : $Barcode_no\n',
                  style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 16.0),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  addUser();
                  print(addUser());
                  fetchProductData();
                  print(fetchProductData());
                },
                child: const Text('Lookup Product'),
              ),
              Text('Product data : $productData\n',
                  style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 16.0),
              const SizedBox(
                height: 10.0,
              ),
              ElevatedButton(
                  onPressed: () {
                    // ignore: unrelated_type_equality_checks
                    if (Barcode_no != "" || Barcode_no == -1) {
                      showAlertDialog(context);
                    } else {
                      showAlert(context);
                    }
                  },
                  child: const Text('Add to cart')),
            ]),
      ),
    );
  }
}
