import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final Color chatColor;
  final String message;

  const ChatBubble({
    super.key,
    required this.chatColor,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: chatColor,
          borderRadius: BorderRadius.circular(30.0)
        ),
        child: Text(
          message,
          style: TextStyle(
            fontFamily: 'Nunito Sans',
            fontSize: 14.0,
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        )
    );
  }
}
