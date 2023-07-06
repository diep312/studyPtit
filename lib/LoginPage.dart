import 'package:flutter/material.dart';
import 'package:flutter_app/Components/TextFieldInput.dart';
import 'package:flutter_app/Components/RoundButton.dart';


class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  void signInUser(){
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
              Text('New here?', style: TextStyle(fontFamily: 'Nunito Sans', fontSize: 15.0)),
              Text('Sign up now!', style: TextStyle(fontFamily: 'Nunito Sans', fontSize: 15.0, color: Colors.blueAccent, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}


