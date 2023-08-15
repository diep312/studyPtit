import 'package:firebase_auth/firebase_auth.dart';

class UserProfile{
  final String userName;
  final String userEmail;
  final String? major;
  final String? briefDescription;
  final String imageURL;
  final String uid;
  final String? contact;
  final String? birthday;

  const UserProfile({
    required this.uid,
    required this.userName,
    required this.userEmail,
    required this.major,
    required this.imageURL,
    required this.briefDescription,
    required this.contact,
    this.birthday
  });

  factory UserProfile.fromJson(Map<String, dynamic> data) {
    return UserProfile(
        uid: data['uid'],
        userName: data['displayName'],
        userEmail: data['email'],
        major: data['major'],
        imageURL: data['profilePicURL'],
        briefDescription: data['briefDesc'],
        contact: data['contactInfo'],
        birthday: data['dateOfBirth']
    );
  }
}