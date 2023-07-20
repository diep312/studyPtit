import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Components/colors.dart';
import 'package:flutter_app/Services/Entity/Profile.dart';
import 'package:flutter_app/Components/RoundButton.dart';
import 'package:flutter_app/Services/chat_service.dart';

class FriendCard extends StatefulWidget {
  final UserProfile userProfile;

  const FriendCard({
    super.key,
    required this.userProfile
  });
  @override
  State<FriendCard> createState() => _FriendCardState();
}

class _FriendCardState extends State<FriendCard> {
  ChatService chatService = ChatService();
  TextStyle _style_1 = TextStyle(
    fontFamily: "Philosopher",
    color: UsedColor.kPrimaryColor,
    fontSize: 18.0,
  );

  TextStyle _style_2 = TextStyle(
    fontFamily: "Nunito Sans",
    color: Colors.black,
    fontSize: 18.0,
  );

  void goToProfile(){
    _modalBottomSheetMenu();
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: goToProfile,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 10,
          left: 40,
          right: 40,
        ),
        child: Container(
          width: 350,
          height: 320,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(widget.userProfile.imageURL),
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    spreadRadius: 8,
                    blurRadius: 8,
                    offset: Offset(3, 3)
                 )],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                      colors: [
                    Color.fromARGB(200, 0, 0, 0),
                    Color.fromARGB(50, 0, 0, 0),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  )
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Text(
                        widget.userProfile.userName,
                        style: TextStyle(
                          fontFamily: 'Philosopher',
                          fontSize: 28.0,
                          color: Colors.white,
                        ),
                      ),
                        Text(
                          widget.userProfile.major,
                          style: TextStyle(
                            fontFamily: "Nunito Sans",
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    Text(
                      widget.userProfile.briefDescription,
                      style: TextStyle(
                          fontFamily: "Nunito Sans",
                          color: Colors.white,
                          fontSize: 14.0,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  void _modalBottomSheetMenu() {
   showModalBottomSheet(
          context: context,
          isDismissible: false,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(30.0),
                  topRight: const Radius.circular(30.0))
          ),
          builder: (builder) {
            return DraggableScrollableSheet(
              initialChildSize: 0.7,
              minChildSize: 0.3,
              maxChildSize: 0.85,
              builder: (_, controller) => Container(
                decoration: BoxDecoration(
                    color: UsedColor.kThirdSecondaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    )
                ),
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: ListView(
                    controller: controller,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 120,
                            width: 80,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(100)
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(widget.userProfile.imageURL),
                                  fit: BoxFit.cover,
                                )
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(20),
                            height: 120,
                            child: Text(
                              widget.userProfile.userName,
                              style: TextStyle(
                                fontSize: 42.0,
                                fontFamily: "Philosopher",
                                color: Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      additionalInfoWidget(),
                      Divider(height: 10),
                      Text("About me", style: TextStyle(fontFamily: "Philosopher", fontSize: 24, fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      Text(widget.userProfile.briefDescription, style: _style_2),
                      SizedBox(height: 50),
                      sendFriendRequestOption(),
                    ],
                  ),
                ),
              ),
            );
          });
  }

  Widget additionalInfoWidget(){
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Email", style: _style_1),
                Text("Major", style: _style_1),
                Text("Contact", style: _style_1),
              ],
            ),
            SizedBox(width: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.userProfile.userEmail, style: _style_2,),
                Text(widget.userProfile.major, style: _style_2,),
                Text("...", style: _style_2,),
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
              return Container(width: 40, height: 40, child: CircularProgressIndicator());
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
                    Navigator.of(context).pop;
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
                ElevatedButton(
                    onPressed: (){
                      chatService.acceptInvite(chatRoomID);
                      Navigator.of(context).pop;
                    },
                    child: Text('Accept')
                ),
                ElevatedButton(onPressed: (){
                  chatService.rejectInvite(chatRoomID);
                  Navigator.of(context).pop;
                },
                    child: Text("Reject")
                )
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
              setState(() {
                sendFriendRequestOption();
              });
            }
        );
      }
    }
  }
}
