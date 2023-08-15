import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Services/Entity/Profile.dart';
import 'package:flutter_app/Pages/Profile/userProfilePage.dart';
import 'package:flutter_app/Components/colors.dart';
import 'package:flutter_app/Components/NotificationCard.dart';

class NotificationPage extends StatefulWidget {
  NotificationPage({super.key});
  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // Get the current user's invitation info.
  CollectionReference usersRef = FirebaseFirestore.instance.collection('users');
  CollectionReference chatRef = FirebaseFirestore.instance.collection('chat_room'); 

  // This function is async because it uses the `await` keyword.
  Future<List<Map<String, dynamic>>> getUsersInfo() async {
    DocumentSnapshot userDoc = await usersRef.doc(FirebaseAuth.instance.currentUser!.uid).get();
    Map<String, dynamic> currUser = userDoc.data() as Map<String, dynamic>;
    List<dynamic> invitationIDs = currUser['invitationsInfo'];
    List<QuerySnapshot> invitations = [];
    for (String invitationID in invitationIDs) {
      QuerySnapshot invitation = await chatRef.doc(invitationID).collection('invitation').orderBy('timestamp', descending: false).get();
      invitations.add(invitation);
    }

    List<Map<String, dynamic>> usersInfo = [];
    for (QuerySnapshot invitation in invitations) {
      for(DocumentSnapshot _invitation in invitation.docs){
        Map <String, dynamic> data = _invitation.data()! as Map<String, dynamic>;
        DocumentSnapshot sender = await usersRef.doc(data['senderID']).get();
        DocumentSnapshot receiver = await usersRef.doc(data['receiverID']).get();
        Map<String, dynamic> user = {
          'sender': UserProfile.fromJson(sender.data() as Map<String, dynamic>),
          'receiver': UserProfile.fromJson(receiver.data() as Map<String, dynamic>),
          'status': data['status'],
          'time' : data['timestamp']
        };
        usersInfo.add(user);
      }
    }
    return usersInfo;
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(30, 20, 0, 10),
                child: Text(
                    "Notification",
                    style: TextStyle(
                        fontFamily: "Philosopher",
                        fontSize: 36.0,
                        fontWeight: FontWeight.bold,
                        color: UsedColor.kSecondaryColor
                    )
                ),
              ),
              SizedBox(height: 20),
              _buildNotification()
            ]
        )
    );
  }

  Widget _buildNotification(){
    return FutureBuilder(
        future: getUsersInfo(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            List<Map<String, dynamic>> usersInfo = snapshot.data!
                .map((value) => value)
                .toList();
            return Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                children: usersInfo.map((user) {
                  if(FirebaseAuth.instance.currentUser!.uid == user['receiver'].uid){
                    if(user['status'] == 'Pending'){
                      return InvitationCard(
                          usersPicURL: user['sender'].imageURL,
                          statusMessage: "sent you a friend request!",
                          displayName: user['sender'].userName,
                          timestamp: user['time'],
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserProfilePage(userProfile: user['sender']),
                                )
                            );
                          }
                      );
                    }
                    if(user['status'] == 'Accepted'){
                      return InvitationCard(
                          usersPicURL: user['sender'].imageURL,
                          statusMessage: "and you have become study buddies!",
                          displayName: user['sender'].userName,
                          timestamp: user['time'],
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserProfilePage(userProfile: user['sender']),
                                )
                            );
                          }
                      );
                    }
                    return Container();
                  }
                  else{
                    if(user['status'] == 'Pending'){
                      return InvitationCard(
                          usersPicURL: user['receiver'].imageURL,
                          statusMessage: "sent ${user['receiver'].userName} a friend request!",
                          displayName: "You",
                          timestamp: user['time'],
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserProfilePage(userProfile: user['receiver']),
                                )
                            );
                          }
                      );
                    }
                    if(user['status'] == 'Accepted'){
                      return InvitationCard(
                          usersPicURL: user['receiver'].imageURL,
                          statusMessage: "and you have become study buddies!",
                          displayName: user['receiver'].userName,
                          timestamp: user['time'],
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserProfilePage(userProfile: user['receiver']),
                                )
                            );
                          }
                      );
                    }
                    return Container();
                  }
                }).toList(),
              ),
            );
          }
          if(snapshot.hasError) {
            return Text("Something went wrong...${snapshot.error}");
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return CircularProgressIndicator();
          }
          return Text("Empty as ever here!");
        }
    );
  }
}
