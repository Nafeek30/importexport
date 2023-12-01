import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:importexport/views/UnpaidOrderScreen.dart';
import 'package:importexport/views/PendingAuthScreen.dart';
import 'package:importexport/views/UserSignupScreen.dart';
import 'package:importexport/views/WorkspaceSignUpScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: 34.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  buildTextField(emailController, 'Email', false),
                  buildTextField(passwordController, 'Password', true),
                  SizedBox(height: 20.0),
                  Container(
                    width: double.infinity,
                    height: 40.0,
                    child: ElevatedButton(
                      onPressed: userLogIn,
                      child: Text('Log In'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.teal[400],
                        onPrimary: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    width: double.infinity,
                    height: 40.0,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserSignUpScreen(),
                          ),
                        );
                      },
                      child: Text('Sign Up'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent[400],
                        onPrimary: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      TextEditingController controller, String label, bool isPassword) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.black87,
          ),
          filled: true,
          fillColor: Colors.grey[100],
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal, width: 2.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(10.0),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        ),
        obscureText: isPassword,
        validator: (value) {
          if (value!.isEmpty) return "Please enter $label";
          if (label == 'Email' && !value.contains('@'))
            return "Enter a valid email";
          if (label == 'Password' &&
              !RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value))
            return "Password must have at least one upper case, one lower case and one number";
          return null;
        },
      ),
    );
  }

  void userLogIn() async {
    final formState = formKey.currentState;
    if (formState!.validate()) {
      formState.save();
      try {
        await auth
            .signInWithEmailAndPassword(
                email: emailController.text, password: passwordController.text)
            .then((value) {
          FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: emailController.text)
              .limit(1)
              .snapshots()
              .first
              .then((snap) {
            if (snap.docs[0].data()['approved'] == 'true' &&
                !snap.docs[0].data()['banned']) {
              // if approved and not banned then show order screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UnpaidOrderScreen(),
                ),
              );
            } else {
              // otherwise move to pending screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PendingAuthScreen(),
                ),
              );
            }
          });
        });
      } catch (error) {
        Fluttertoast.showToast(
            msg: error.toString(),
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
    }
  }
}
