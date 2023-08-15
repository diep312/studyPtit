import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class InvitationCard extends StatefulWidget {
  final String usersPicURL;
  final String statusMessage;
  final String displayName;
  final Timestamp timestamp;
  final Function()? onTap;

  const InvitationCard({
    super.key,
    required this.usersPicURL,
    required this.statusMessage,
    required this.displayName,
    required this.timestamp,
    required this.onTap,
  });

  @override
  State<InvitationCard> createState() => _InvitationCardState();
}

class _InvitationCardState extends State<InvitationCard> {
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
                    radius: 30,
                    backgroundImage: NetworkImage(widget.usersPicURL),
                  )
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.0),
                  Container(
                    width: 280,
                    child: Text(
                      "${widget.displayName} ${widget.statusMessage}",
                      style: TextStyle(
                          fontFamily: "Nunito Sans",
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                      ),
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    _dateTimeFromFirebaseTimestamp(widget.timestamp),
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

  String _dateTimeFromFirebaseTimestamp(Timestamp firebaseTimestamp) {
    DateTime dateTime = firebaseTimestamp.toDate();
    return DateFormat.yMMMd().add_jm().format(dateTime);
  }
}
