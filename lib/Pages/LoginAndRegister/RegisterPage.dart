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
  String nameMessage = '';


  void signUserIn() async {
    if(passwordController.text.length >= 8){
      if(passwordController.text == re_passwordController.text){
        setState(() {
          passwordMessage = "";
        });
        if(nameController.text.isNotEmpty && usernameController.text.isNotEmpty){
          setState(() {
            nameMessage = "";
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
            showDialog(
                context: context,
                builder: (context){
                  return AlertDialog(
                      backgroundColor: Colors.grey[300],
                      title: Center(
                        child: Text(
                          e.toString(),
                          style: TextStyle(fontSize: 20.0),
                        ),
                      )
                  );
                }
            );
          }
        }
        else{
          setState(() {
            nameMessage = "Don't leave any field empty!";
          });
        }
      }
      else{
        setState(() {
          passwordMessage = "You must enter password correctly!";
        });
      }
    }
    else{
      setState(() {
        passwordMessage = "Password must be at least 8 characters!";
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
            children:[ Text("Register", style: TextStyle(
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Text(nameMessage, style: TextStyle(color: Colors.red, fontSize: 12.0))],
                ),
              ),
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
            ),
            ]
          ),
        ),
      ),
    );
  }
}
