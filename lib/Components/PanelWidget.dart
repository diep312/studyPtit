import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/Components/RoundButton.dart';
import 'package:flutter_app/Components/usersAlbumView.dart';
import 'package:flutter_app/Services/Entity/Profile.dart';
import 'package:flutter_app/Components/colors.dart';
import 'package:flutter_app/Services/chat_service.dart';

class PanelWidget extends StatefulWidget {
  final ScrollController controller;
  final UserProfile userProfile;
  const PanelWidget({
    super.key,
    required this.controller,
    required this.userProfile
  });

  @override
  State<PanelWidget> createState() => _PanelWidgetState();
}

class _PanelWidgetState extends State<PanelWidget> {
  ChatService chatService = ChatService();
  TextStyle _style_1 = TextStyle(
    fontFamily: "Philosopher",
    color: UsedColor.kPrimaryColor,
    fontSize: 20.0,
  );

  TextStyle _style_2 = TextStyle(
    fontFamily: "Nunito Sans",
    color: Colors.black,
    fontSize: 18.0,
  );

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(20),
      controller: widget.controller,
      children: [
        Center(
          child: Container(
            height: 5,
            width: 30,
            decoration: BoxDecoration(
              color: Colors.grey[300]
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(20),
          height: 150,
          child: Center(
            child: Text(
              widget.userProfile.userName,
              style: TextStyle(
                fontSize: 40.0,
                fontFamily: "Philosopher",
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 3,
              overflow: TextOverflow.visible,
            ),
          ),
        ),
        const SizedBox(height: 20),
        additionalInfoWidget(),
        const Divider(height: 10),
        Text("About me", style: TextStyle(fontFamily: "Philosopher", fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Text(widget.userProfile.briefDescription!, style: _style_2),
        const SizedBox(height: 50),
        sendFriendRequestOption(),
        const SizedBox(height: 50),
        userAlbumList(userUID: widget.userProfile.uid),
      ],
    );
  }

  Widget additionalInfoWidget(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
      child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Email", style: _style_1),
                Text("Major", style: _style_1),
                Text("Birthday", style: _style_1),
                Text("Contact", style: _style_1),
              ],
            ),
            SizedBox(width: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.userProfile.userEmail, style: _style_2, maxLines: 1, overflow: TextOverflow.fade,),
                Text(widget.userProfile.major!, style: _style_2, maxLines: 1, overflow: TextOverflow.fade,),
                Text(widget.userProfile.birthday!, style: _style_2, maxLines: 1, overflow: TextOverflow.fade,),
                Text(widget.userProfile.contact!, style: _style_2,  maxLines: 1, overflow: TextOverflow.fade,),
              ],
            )
          ]
      ),
    );
  }
  Widget sendFriendRequestOption(){
    String currentUserID = FirebaseAuth.instance.currentUser!.uid;
    String userUID = widget.userProfile.uid;
    List<String> ids = [currentUserID, userUID];
    ids.sort();
    String chatRoomID = ids.join("_");
    late Future<QuerySnapshot> invitationData = chatService.getInvitationdata(chatRoomID);
    return FutureBuilder<QuerySnapshot>(
        future: invitationData,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong...");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasData && snapshot.data!.size != 0) {
            if (snapshot.data!.docs.first.exists) {
              final doc = snapshot.data!.docs.first;
              return _buildButton(doc);
            }
          }
          else{
            return RoundButton(
                btnHeight: 40,
                btnWidth: 120,
                descText: "Send study buddy request?",
                onPressed: (){
                  chatService.sendInvite(widget.userProfile.uid.toString());
                }
            );
          }
          return Text("Something went wrong...");
        }
    );

  }

  Widget _buildButton(DocumentSnapshot document){
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    List<String> ids = [data['senderID'], data['receiverID']];
    ids.sort();
    String chatRoomID = ids.join("_");
    if(data['status'] == "Pending"){
      if(data['senderID'] == FirebaseAuth.instance.currentUser!.uid){
        return Container(
          width: 120,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(30))
          ),
          child: Center(child: Text("Invitation sent!", style: TextStyle(fontFamily: "Philosopher", fontSize: 20, fontWeight: FontWeight.bold, color: UsedColor.kSecondaryColor))),
        );
      }
      else{
        return Column(
            children: [SizedBox(
              width: 160,
              height: 40,
              child: Text("Accept invitation?", style: TextStyle(fontFamily: "Philosopher", fontSize: 20, fontWeight: FontWeight.bold, color: UsedColor.kSecondaryColor)),
            ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RoundButton(
                    btnWidth: 100,
                    btnHeight: 50,
                    descText: "Accept",
                    onPressed: (){
                      chatService.acceptInvite(chatRoomID);
                      setState(() {});
                    },
                  ),
                 RoundButton(
                   btnHeight: 50,
                   btnWidth: 100,
                   descText: "Reject",
                   onPressed: (){
                     chatService.rejectInvite(chatRoomID);
                     setState(() {});
                   },
                 ),
                ],
              )
            ]
        );
      }
    }
    else{
      if(data['status'] == "Accepted"){
        return Container(
          width: 120,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(30))
          ),
          child: Center(child: Text("You are already study buddies!", style: TextStyle(fontFamily: "Philosopher", fontSize: 20, fontWeight: FontWeight.bold, color: UsedColor.kSecondaryColor))),
        );
      }
      else{
        return RoundButton(
            btnHeight: 40,
            btnWidth: 120,
            descText: "Send study buddy request?",
            onPressed: (){
              chatService.sendInvite(widget.userProfile.uid.toString());
            }
        );
      }
    }
  }
}
