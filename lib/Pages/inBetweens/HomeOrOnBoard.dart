import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Pages/Home/HomePage.dart';
import 'package:flutter_app/Pages/OnBoard/OnBoardPage.dart';

class OnBoardState extends StatefulWidget {
  const OnBoardState({super.key});

  @override
  State<OnBoardState> createState() => _OnBoardStateState();
}

class _OnBoardStateState extends State<OnBoardState> {
  bool hasSeenOnboard = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get().then(
             (document){
               Map<String, dynamic> data = document.data() as Map<String, dynamic>;
               hasSeenOnboard = data['hasSeenOnBoarding'];
             }
     );
  }
  @override
  Widget build(BuildContext context) {
    return hasSeenOnboard ? HomePage() : OnBoard();
  }
}
