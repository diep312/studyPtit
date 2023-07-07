import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Components/colors.dart';
import 'package:flutter_app/Components/TextFieldInput.dart';
import 'package:flutter_app/Components/RoundButton.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final re_passwordController = TextEditingController();
  String passwordMessage = '';

  void signUserIn() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
    );

    try {
      if(passwordController.text == re_passwordController.text){
        setState(() {
          passwordMessage = "";
        });
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: usernameController.text,
            password: passwordController.text
        );
        Navigator.pop(context);
        Navigator.pop(context);
      }
      else{
        Navigator.pop(context);
        setState(() {
          passwordMessage = "You must enter password correctly!";
        });
      }
    } on FirebaseAuthException catch (e){
      Navigator.pop(context);

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
                SizedBox(height: 30.0),
                InputTextField(
                    controller: usernameController,
                    hintText: 'Email',
                    descText: 'Enter your email here',
                    obscureText: false
                ),
                SizedBox(height: 20.0),
                InputTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    descText: 'Enter your password here',
                    obscureText: true
                ),
                SizedBox(height: 20.0),
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
