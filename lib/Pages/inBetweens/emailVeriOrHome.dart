import 'dart:async';
import 'package:flutter_app/Components/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Pages/inBetweens/HomeOrOnBoard.dart';

class VerifyEmailState extends StatefulWidget {
  const VerifyEmailState({super.key});

  @override
  State<VerifyEmailState> createState() => _VerifyEmailStateState();
}

class _VerifyEmailStateState extends State<VerifyEmailState> {
  bool isEmailVerified = false;
  bool canResendEmail = true;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if(!isEmailVerified){
      sendVerificationEmail();

      timer = Timer.periodic(Duration(seconds: 3), (_) => checkEmailVerified());
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() {
        canResendEmail = false;
      });
      await Future.delayed(Duration(seconds: 20));
      setState(() {
        canResendEmail = true;
      });

    } catch (e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  Future checkEmailVerified() async{
    await FirebaseAuth.instance.currentUser!.reload();
   setState(() {
     isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
   });
   if(isEmailVerified) timer?.cancel();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isEmailVerified ? OnBoardState() : Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: UsedColor.kPrimaryColor,
          title: const Text("Email Verification",
            style: TextStyle(
              fontFamily: "Philosopher",
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.asset(
                    'asset/Logo.png',
                    fit: BoxFit.fill,
                  )
              ),
              SizedBox(height: 20),
              Text(
              "A verification email has been sent to your email! Please check your email.",
            style: TextStyle(
              fontFamily: "Philosopher",
              fontSize: 35.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              ),
                textAlign: TextAlign.center,
            ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(90),
                      )
                ),
                  onPressed: (){
                    canResendEmail ? sendVerificationEmail() : null;
                  },
                  label: Text("Resend Email",
                    style: TextStyle(
                      fontFamily: "Nunito Sans",
                      fontSize: 24.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  icon: Icon(Icons.email, size: 32),
              ),
              TextButton(
                  onPressed: (){
                    FirebaseAuth.instance.signOut();
                  },
                  child: Text("Cancel",
                  style: TextStyle(
                    fontFamily: "Nunito Sans",
                    fontSize: 20,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold
                  ),
                  )
              )
            ]
          ),
        ),
      ),
    );
  }
}
