import 'package:flutter/material.dart';

class ContactList extends StatefulWidget {

  final String displayName;
  final String lastMessage;
  final String profilePicURL;
  final Function()? onTap;

  const ContactList({
    super.key,
    required this.displayName,
    required this.lastMessage,
    required this.profilePicURL,
    required this.onTap
  });

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: 380,
        height: 90,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: [
              Container(
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(widget.profilePicURL),
                  )
              ),
              SizedBox(width: 10),
              Column(
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
                  Text(
                      widget.lastMessage,
                    style: TextStyle(
                      fontFamily: "Nunito Sans",
                      fontSize: 12.0,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
