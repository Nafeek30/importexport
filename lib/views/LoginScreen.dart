import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Align(
        alignment: Alignment.center,
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 32,
          ),
          child: Center(
            child: Column(
              children: [
                Text('hi'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
