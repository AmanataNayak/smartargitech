import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class MyHomePage extends StatefulWidget {
  static const route = '/notification-screen';
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  int _switchValue = 0;
  int _soilMoisture = 0;

  final DatabaseReference _isOnRef =
      FirebaseDatabase.instance.reference().child('isOn');
  final DatabaseReference _soilMoistureRef =
      FirebaseDatabase.instance.reference().child('int');

  @override
  void initState() {
    super.initState();
    _isOnRef.onValue.listen((event) {
      setState(() {
        _switchValue = (event.snapshot.value ?? 0) as int;
      });
    });

    _soilMoistureRef.onValue.listen((event) {
      setState(() {
        _soilMoisture = (event.snapshot.value ?? 0) as int;
      });
    });
  }

  void signOutUser() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: signOutUser, icon: const Icon(Icons.logout))
        ],
        centerTitle: true,
        title: const Text(
          'Smart Drip Irrigation',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome, ',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  user.email!,
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            const Text(
              'Soil Moisture Level:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              '$_soilMoisture',
              style: TextStyle(
                fontSize: 24.0,
                color: _soilMoisture > 50 ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Water Flow:',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Switch(
                  activeColor: Colors.green,
                  value: _switchValue == 1,
                  onChanged: (value) {
                    setState(() {
                      _switchValue = value ? 1 : 0;
                    });
                    _isOnRef.set(_switchValue);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
