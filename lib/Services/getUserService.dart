import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_app/Services/Entity/Profile.dart';

class GetUserService extends ChangeNotifier{
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream <QuerySnapshot> getUserList(){
    return _firebaseFirestore
        .collection('users').where("uid",  isNotEqualTo: _firebaseAuth.currentUser!.uid.toString())
        .orderBy('uid', descending: false)
        .snapshots();
  }



  Stream<QuerySnapshot> getUsersStream(List<String> userIds) {
    return FirebaseFirestore.instance
        .collection('users')
        .where(FieldPath.documentId, whereIn: userIds)
        .snapshots();
  }

  Stream<QuerySnapshot> getFriendsStream(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .asyncMap((DocumentSnapshot document) async {
      List<String> friendIds = List<String>.from(document.get('friendList'));
      return getUsersStream(friendIds).first;
    });
  }
}