import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Pages/RegisterPage.dart';
import 'package:flutter_app/Components/TextFieldInput.dart';
import 'package:flutter_app/Components/RoundButton.dart';


class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void signInUser() async {
    showDialog(
        context: context,
        builder: (context)  {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
    );

    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: usernameController.text,
        password: passwordController.text,
      );
      Navigator.pop(context);

    } on FirebaseAuthException catch (e){
      Navigator.pop(context);
      switch (e.code){
        case 'user-not-found':
          displayErrorMessage("Invalid user!");
          break;
        case 'wrong-password':
          displayErrorMessage("Incorrect password!");
          break;
        case 'unknown':
          displayErrorMessage("Please enter Email/Password correctly!");
          break;
        default:
          displayErrorMessage(e.code);
      }
    }
  }

  void displayErrorMessage(String message){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            backgroundColor: Colors.grey[300],
            title: Center(
              child: Text(
                message,
                style: TextStyle(fontSize: 20.0),
              ),
            )
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 0)),
              //Welcome
              SizedBox(
                height: 120.0,
                width: 250.0,
                child: Text(
                    'Welcome to STUDYPTIT',
                    style: TextStyle(
                      fontSize: 48.0,
                      fontFamily: 'Philosopher',
                      color: Colors.black,
                    ),
                ),
              ),
              SizedBox(height: 30.0,),
              //Login
              InputTextField(
                controller: usernameController,
                descText: 'Enter your email here',
                hintText: 'Email',
                obscureText: false,),

              SizedBox(height: 20.0),
              //Password
              InputTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  descText: 'Enter password here',
                  obscureText: true),
              //Forgot pass
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [Text('Forgot password?', style: TextStyle(color: Colors.black26))],
                ),
              ),
              SizedBox(height: 50.0),

              //Login button
              RoundButton(
                  btnHeight: 60.0,
                  btnWidth: 175.0,
                  descText: 'Sign In',
                  onPressed: signInUser
              ),
              //Divider
              SizedBox(height: 50.0,),
              Image.asset('asset/Cat_Icon.png'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('New here?', style: TextStyle(fontFamily: 'Nunito Sans', fontSize: 15.0)),
                  TextButton(
                      onPressed: (){
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Container(
                          padding: EdgeInsets.all(0.0),
                          child: Text('Sign up now!', style: TextStyle(fontFamily: 'Nunito Sans', fontSize: 15.0, color: Colors.blueAccent, fontWeight: FontWeight.bold)))
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}


