import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Components/colors.dart';
import 'package:flutter_app/Pages/Message/ChatPage.dart';
import 'package:flutter_app/Components/ContactList.dart';
import 'package:flutter_app/Services/getUserService.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GetUserService _getUserService = GetUserService();



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(30, 20, 0, 10),
            child: Text(
              "Messages",
              style: TextStyle(
                fontFamily: "Philosopher",
                fontSize: 36.0,
                fontWeight: FontWeight.bold,
                color: UsedColor.kSecondaryColor
              )
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
                "Study Buddy List",
                style: TextStyle(
                  fontFamily: "Nunito Sans",
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                )
            ),
          ),
          _buildUserList()
        ],
      )
    );
  }


  Widget _buildUserList(){
    return StreamBuilder<QuerySnapshot>(
        stream: _getUserService.getFriendsStream(_auth.currentUser!.uid),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const CircularProgressIndicator();
          }
          if(snapshot.hasData && snapshot.data!.size != 0){
            return Expanded(
              child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  children: snapshot.data!.docs
                      .map<Widget>((doc) => _buildUserListItem(doc)).toList()
              ),
            );
          }
          return Text("You have no friends...");
        }
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        return ContactList(
          friendUserID: data['uid'],
          curUserID: _auth.currentUser!.uid,
          displayName: data['displayName'],
          profilePicURL: data['profilePicURL'],
          onTap: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatPage(
                      receiverUserDisplayName: data['displayName'],
                      receiverUserID: data['uid'],
                      receiverUserProfilePic: data['profilePicURL'],
                    ),
                )
            );
          },
        );
      }
}
