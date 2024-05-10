import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iot_app/pages/homePage.dart';
import 'package:iot_app/pages/loginOrRegisterPage.dart';
import 'package:iot_app/pages/loginPage.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Placeholder(
      child: Scaffold(
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(), 
          builder: (context,snapshot){
            if (snapshot.hasData){
              return MyHomePage();
            }else{
              return const LoginOrRegisterPage();
            }
          },
        ),
      ),
    );
  }
}