import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:iot_app/api/firebase_api.dart';
import 'package:iot_app/firebase_options.dart';
import 'package:iot_app/pages/authPage.dart';
import 'package:iot_app/pages/homePage.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAPI().initNotification();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Argitech',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      navigatorKey: navigatorKey,
      home: const AuthPage(),
      routes: {
        MyHomePage.route:(context)=>  MyHomePage()
      },
    );
  }
}

