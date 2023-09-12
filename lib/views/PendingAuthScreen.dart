import 'package:flutter/material.dart';

class PendingAuthScreen extends StatefulWidget {
  const PendingAuthScreen({super.key});

  @override
  PendingAuthScreenState createState() => PendingAuthScreenState();
}

class PendingAuthScreenState extends State<PendingAuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  'Your account is pending authorization. Wait for the owner to approve you.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
