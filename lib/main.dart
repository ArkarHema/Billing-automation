import 'package:bill_automation/SecondPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Login'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController trolleyController = TextEditingController();

  showAlertDialog(BuildContext context) {
    // Widget cancelButton = TextButton(
    //   child: const Text("Cancel"),
    //   onPressed: () {
    //     Navigator.of(context).pop();
    //   },
    // );
    Widget continueButton = TextButton(
      child: const Text("Continue"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      /*title: const Text(""),*/
      content: const Text("Please fill all the details"),
      actions: [
        // cancelButton,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(hintText: "Name"),
            ),
            const SizedBox(
              height: 14.0,
            ),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(hintText: "Email"),
            ),
            const SizedBox(
              height: 14.0,
            ),
            TextFormField(
              controller: phoneController,
              decoration: const InputDecoration(hintText: "Phone number"),
            ),
            const SizedBox(
              height: 14.0,
            ),
            TextFormField(
              controller: trolleyController,
              decoration: const InputDecoration(hintText: "Trolley number"),
            ),
            const SizedBox(
              height: 24.0,
            ),
            ElevatedButton(
              onPressed: () {
                var name = nameController.text.trim();
                var email = emailController.text.trim();
                var phone = phoneController.text.trim();
                var trolley = trolleyController.text.trim();
                if (name != "" && email != "" && phone != "" && trolley != "") {
                  try {
                    FirebaseFirestore.instance
                        .collection("customers")
                        .doc()
                        .set({
                      "Name": name,
                      "Email": email,
                      "Phone": phone,
                      "Trolley": trolley,
                    });
                  } catch (e) {
                    print(e);
                  }
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SecondPage()));
                } else {
                  showAlertDialog(context);
                }
              },
              child: const Text("Login"),
            )
          ],
        ),
      ),
    );
  }
}
