import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/Pages/inBetweens/emailVeriOrHome.dart';
import '../Pages/LoginAndRegister/LoginPage.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({
    super.key,
  });

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              return VerifyEmailState();
            }
            else{
              return LoginPage();
            }
          },
        ),
    );
  }
}
