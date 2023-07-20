import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  void searchMessage(){

  }

  final currSearch = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "Messages",
              style: TextStyle(
                fontFamily: "Philosopher",
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              )
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
                width: 250,
                child: TextField(
                  controller: currSearch,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white38),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.brown)
                    ),
                    hintText: "Search something...",
                    hintStyle: TextStyle(
                      color: Colors.blueGrey,
                    )
                  ),
                ),
              ),
              IconButton(
                  onPressed: searchMessage,
                  icon: Icon(Icons.search),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildUserList()
        ],
      )
    );
  }
  
  
  Widget _buildUserList(){
    return StreamBuilder<QuerySnapshot>(
        stream: _getUserService.getFriendsStream(_auth.currentUser!.uid),
        builder: (context, snapshot){
          if(snapshot.hasError){
            return const Text("Error");
          }

          if(snapshot.connectionState == ConnectionState.waiting){
            return const CircularProgressIndicator();
          }

          if(snapshot.hasData && snapshot.data!.size != 0){
            return ListView(
                shrinkWrap: true,
                children: snapshot.data!.docs
                    .map<Widget>((doc) => _buildUserListItem(doc)).toList()
            );
          }

          return Text("You have no friends...");
        }
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;

      if(_auth.currentUser!.email != data['email']){
        return ContactList(
          displayName: data['displayName'],
          lastMessage: "",
          profilePicURL: data['profilePicURL'],
          onTap: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatPage(
                      receiverUserDisplayName: data['displayName'],
                      receiverUserID: data['uid'],
                    ),
                )
            );
          },
        );
      }
      else {
       return Container();
      }
  }
}
