import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iot_app/components/button.dart';
import 'package:iot_app/components/text_field.dart';
import 'package:iot_app/pages/loginPage.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();
  void wrongMsg(String txt) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(txt),
          );
        });
  }

  void resetPassword() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );
      Navigator.pop(context);
      wrongMsg('Password Reset Email Sent');
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      wrongMsg(e.code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Placeholder(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              const Icon(
                Icons.lock,
                size: 100,
              ),
              const SizedBox(
                height: 50,
              ),
              const Text(
                'Reset Password',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(
                height: 50,
              ),
              MyTextFields(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),
              const SizedBox(
                height: 50,
              ),
              MyButton(
                onTap: resetPassword,
                text: 'Reset Password',
              ),
              const SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginPage(
                            onTap: () {},
                          )),
                ),
                child: const Text(
                  'Login Now',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
