import 'package:flutter/material.dart';
import 'package:flutter_app/Services/chat_service.dart';

class ContactList extends StatefulWidget {
  final String curUserID;
  final String friendUserID;
  final String displayName;
  final String profilePicURL;
  final Function()? onTap;

  const ContactList({
    super.key,
    required this.curUserID,
    required this.friendUserID,
    required this.displayName,
    required this.profilePicURL,
    required this.onTap
  });

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  final _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: 380,
        height: 100,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: [
              Container(
                  child: CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(widget.profilePicURL),
                  )
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.0),
                  Text(
                    widget.displayName,
                    style: TextStyle(
                      fontFamily: "Nunito Sans",
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 10.0),
                  _buildGetLastSentMessage(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGetLastSentMessage(){
    return FutureBuilder(
        future: _chatService.getLastSentMessage(widget.curUserID, widget.friendUserID, widget.displayName),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Text("...");
          }
          if(!snapshot.hasData) {
            return Text("");
          }
          return Container(
            width: 250,
            child: Text(
              snapshot.data!.toString(),
              style: TextStyle(
                fontFamily: "Nunito Sans",
                fontSize: 16.0,
              ),
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }
    );
  }
}
