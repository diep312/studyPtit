import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Services/chat_service.dart';
import 'package:flutter_app/Components/TextFieldInput.dart';
import 'package:flutter_app/Components/chatBubble.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserDisplayName;
  final String receiverUserID;

  const ChatPage({
    super.key,
    required this.receiverUserDisplayName,
    required this.receiverUserID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService(); 
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance; 
  
  void sendMessage() async{
    if(_messageController.text.isNotEmpty){
      await _chatService.sendMessage(
      widget.receiverUserID,
      _messageController.text
      );
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverUserDisplayName)
      ),
      body: Column(
        children: [
          Expanded(
              child: _buildMessageList(),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList(){
    return StreamBuilder(
      stream: _chatService.getMessages(
        _firebaseAuth.currentUser!.uid,
        widget.receiverUserID),
      builder: (context, snapshot){
        if(snapshot.hasError){
          return Text("Error ${snapshot.error}");
        }
        if(snapshot.connectionState == ConnectionState.waiting){
          return Text("Loading...");
        }
        return ListView(
          children: snapshot.data!.docs.map(
                  (document) => _buildMessageItem(document))
                  .toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document){
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    var alignment, nameDisplay, crossAlign, chatColor;

    if(data['senderID'] == _firebaseAuth.currentUser!.uid){
      alignment = Alignment.centerRight;
      nameDisplay = "Me";
      crossAlign = CrossAxisAlignment.end;
      chatColor = Colors.green;
    }
    else{
      alignment = Alignment.centerLeft;
      nameDisplay = widget.receiverUserDisplayName;
      crossAlign = CrossAxisAlignment.start;
      chatColor = Colors.blue;
    }

    return Container(
      alignment: alignment,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: crossAlign,
          children: [
            Text(
                nameDisplay,
              style: TextStyle(
                fontFamily: "Philosopher",
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2.0),
            ChatBubble(
              chatColor: chatColor,
              message: data['message']
            ),
          ],
        ),
      )
    );
  }


  Widget _buildMessageInput(){
    return Row(
      children: [
        Expanded(
          child: InputTextField(
            controller: _messageController,
            descText: "Say something...",
            hintText: "",
            obscureText: false,
          )
        ),
        IconButton(
            onPressed: sendMessage,
            icon: const Icon(
              Icons.arrow_upward,
              size: 40,
            )
        )
      ],
    );
  }
}
