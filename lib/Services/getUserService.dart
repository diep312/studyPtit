import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/Services/Entity/Profile.dart';

class GetUserService extends ChangeNotifier{
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream <QuerySnapshot> getUserList() {
    return _firebaseFirestore
        .collection('users').where(
        "uid", isNotEqualTo: _firebaseAuth.currentUser!.uid.toString()).limit(4)
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

  Future<void> updateProfile(TextEditingController dateOfBirth, TextEditingController major, TextEditingController contact) async {
    final userID = _firebaseAuth.currentUser!.uid;
    final usersRef = FirebaseFirestore.instance.collection('users');
    final updatedProfile = {
      'contactInfo': contact.text,
      'major': major.text,
      'dateOfBirth': dateOfBirth.text,
    };
    await usersRef.doc(userID).update(updatedProfile);
  }

  Future<UserProfile> getUserProfile(String userId) async {
    DocumentReference documentReference =
    FirebaseFirestore.instance.collection('users').doc(userId);
    DocumentSnapshot documentSnapshot = await documentReference.get();
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    return UserProfile.fromJson(data);
  }

}