import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Components/colors.dart';
import 'package:flutter_app/Components/TextFieldInput.dart';
import 'package:flutter_app/Components/RoundButton.dart';
import 'package:flutter_app/Services/auth_service.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final re_passwordController = TextEditingController();
  final nameController = TextEditingController();
  String passwordMessage = '';

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  void signUserIn() async {
    if(passwordController.text == re_passwordController.text){
      setState(() {
        passwordMessage = "";
      });
      try {
        final authService = Provider.of<AuthService>(context, listen: false);
        authService.signUpwithEmailAndPassword(
            nameController.text,
            usernameController.text,
            passwordController.text
        );
        Navigator.pop(context);

      } on FirebaseAuthException catch (e){
        throw Exception(e.code);
      }
    }
    else{
      setState(() {
        passwordMessage = "You must enter password correctly!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: appcolors.shade500,
      ),
      backgroundColor: appcolors.shade500,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children:[ Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children:[
                Text("Register", style: TextStyle(
                  fontSize: 50.0,
                  fontFamily: "Philosopher",
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                  ),
                ),
                SizedBox(height: 10.0),
                InputTextField(
                    controller: usernameController,
                    hintText: 'Email',
                    descText: 'Enter your email here',
                    obscureText: false
                ),
                SizedBox(height: 10.0),
                InputTextField(
                    controller: nameController,
                    hintText: "Name",
                    descText: "Enter your name here",
                    obscureText: false),
                SizedBox(height: 10.0),
                InputTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    descText: 'Enter your password here',
                    obscureText: true
                ),
                SizedBox(height: 10.0),
                InputTextField(
                    controller: re_passwordController,
                    hintText: 'Re-enter Password',
                    descText: 'Re-enter your password here',
                    obscureText: true
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [Text(passwordMessage, style: TextStyle(color: Colors.red, fontSize: 12.0))],
                  ),
                ),
                SizedBox(height: 30.0),
                RoundButton(
                    btnHeight: 60,
                    btnWidth: 180,
                    descText: "Sign up",
                    onPressed: signUserIn
                )
              ]),
              Align(alignment: Alignment.bottomCenter, child: Image.asset('asset/Decor.png', fit: BoxFit.fill))
            ]
          ),
        ),
      ),
    );
  }
}
