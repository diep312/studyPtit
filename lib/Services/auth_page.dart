import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Pages/LoginAndRegister/LoginPage.dart';
import '../Pages/Home/HomePage.dart';
import 'package:flutter_app/Pages/OnBoard/OnBoardPage.dart';


class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return HomePage();
          }
          else{
            return LoginPage();
          }
        },
      ),
    );
  }
}
