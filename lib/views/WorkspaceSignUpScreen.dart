import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:importexport/views/OrderScreen.dart';
import 'package:importexport/views/UserSignupScreen.dart';

class WorkspaceSignUpScreen extends StatefulWidget {
  const WorkspaceSignUpScreen({super.key});

  @override
  WorkspaceSignUpScreenState createState() => WorkspaceSignUpScreenState();
}

class WorkspaceSignUpScreenState extends State<WorkspaceSignUpScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          color: Colors.black87,
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserSignUpScreen(),
              ),
            );
          },
        ),
      ),
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
                    'Create a Workspace',
                    style: TextStyle(
                      fontSize: 34.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  buildTextField(firstNameController, 'First Name', false),
                  buildTextField(lastNameController, 'Last Name', false),
                  buildTextField(phoneNumberController, 'Phone Number', false),
                  buildTextField(emailController, 'Email', false),
                  buildTextField(passwordController, 'Password', true),
                  SizedBox(height: 20.0),
                  Container(
                    width: double.infinity,
                    height: 40.0,
                    child: ElevatedButton(
                      onPressed: workplaceSignUp,
                      child: Text('Sign Up'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.teal[400],
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

  void workplaceSignUp() async {
    final formState = formKey.currentState;
    if (formState!.validate()) {
      formState.save();
      try {
        await auth
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text)
            .then((value) {
          Map<String, String> dataToSave = {
            'owner': emailController.text,
            'code': 'ABCD',
          };

          Map<String, dynamic> userDataToSave = {
            'firstName': firstNameController.text,
            'lastName': lastNameController.text,
            'email': emailController.text,
            'phoneNumber': phoneNumberController.text,
            'code': 'ABCD',
            'approved': true,
          };
          FirebaseFirestore.instance
              .collection('workspace')
              .doc()
              .set(dataToSave)
              .then((value) {
            FirebaseFirestore.instance
                .collection('users')
                .doc()
                .set(userDataToSave)
                .then((value) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderScreen(),
                ),
              );
              Fluttertoast.showToast(
                  msg: 'Sign Up Successful',
                  backgroundColor: Colors.teal,
                  textColor: Colors.white);
            });
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
