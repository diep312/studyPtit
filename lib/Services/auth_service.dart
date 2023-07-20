import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<UserCredential> signInwithEmailAndPassword(String email, String password) async {
    try{
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password
      );

      _firebaseFirestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      },SetOptions(merge:true));

      return userCredential;
    }
    on FirebaseAuthException catch (e){
      throw Exception(e.code);
    }
  }

  Future<UserCredential> signUpwithEmailAndPassword(String name, String email, String password) async{
    try{
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      _firebaseFirestore.collection('users').doc(userCredential.user!.uid).set(
      {
        "uid": userCredential.user!.uid,
        "email": email,
        "displayName": name,
        "friendList": [],
        "profilePicURL": "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fmoonvillageassociation.org%2Fwp-content%2Fuploads%2F2018%2F06%2Fdefault-profile-picture1.jpg&f=1&nofb=1&ipt=fc0a9779ab06a6227a06f5784f28daf6a215c88324f2a87098f758f386474c35&ipo=images",
        "briefDesc": "",
        "major" : "",
      });

      return userCredential;
    }
    on FirebaseAuthException catch (e){
      throw Exception(e.code);
    }
  }

  Future<void> signOut()  async {
    return await FirebaseAuth.instance.signOut();
  }
}