import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class sample extends StatefulWidget {
  const sample({Key? key}) : super(key: key);

  @override
  State<sample> createState() => _sampleState();
}

class _sampleState extends State<sample> {
  String name = '';
  @override
  Widget build(BuildContext context) {
    void read() async {
      var collection =
          FirebaseFirestore.instance.collection('products_available');
      var docSnapshot = await collection.doc('8904155972644').get();
      print(collection);
      print(docSnapshot.data());
      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data();
        var value = data?['Name_of_prod'];
        print(value);
        // <-- The value you want to retrieve.
        setState(() {
          name = value;
        });
      } else {
        print("no");
      }
    }

    return Scaffold(
        body: Center(
      child: ElevatedButton(
          onPressed: () {
            read();
            print(name);
          },
          child: const Text('Read')),
    ));
  }
}
