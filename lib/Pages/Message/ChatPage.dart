import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Components/colors.dart';
import 'package:flutter_app/Services/chat_service.dart';
import 'package:flutter_app/Components/chatBubble.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';



class ChatPage extends StatefulWidget {
  final String receiverUserDisplayName;
  final String receiverUserID;
  final String receiverUserProfilePic;

  const ChatPage({
    super.key,
    required this.receiverUserDisplayName,
    required this.receiverUserID,
    required this.receiverUserProfilePic
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  ScrollController _scrollController = ScrollController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FocusNode focusNode = FocusNode();
  
  void sendMessage() async{
    if(_messageController.text.isNotEmpty){
      await _chatService.sendMessage(
      widget.receiverUserID,
      _messageController.text
      );
      _messageController.clear();
      _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 100,
        title: Column(
          children:[ CircleAvatar(
            backgroundImage: NetworkImage(widget.receiverUserProfilePic),
            radius: 30,
          ),
            Text(
              widget.receiverUserDisplayName,
              style: TextStyle(
                  fontFamily: "Philosopher",
                  fontSize: 30.0,
                  color: UsedColor.kThirdSecondaryColor
              ),
            ),
          ]
        ),
        centerTitle: true,
        backgroundColor: UsedColor.kPrimaryColor,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
            },
          icon: Icon(Icons.arrow_back_ios_rounded, size: 30,),
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: _buildMessageList(),
          ),
          Container(
              height: 70,
              child: _buildMessageInput()
          ),
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

        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty && _scrollController.positions.isNotEmpty ){
          _scrollController.jumpTo(
            _scrollController.position.maxScrollExtent,
          );
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });

        return ListView(
          controller: _scrollController,
          physics: AlwaysScrollableScrollPhysics(),
          children: snapshot.data!.docs.map(
                  (document) => _buildMessageItem(document))
                  .toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document){
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    var alignment, nameDisplay, crossAlign, chatColor, edgeInsets;

    if(data['senderID'] == _firebaseAuth.currentUser!.uid){
      alignment = Alignment.centerRight;
      nameDisplay = "Me";
      crossAlign = CrossAxisAlignment.end;
      chatColor = Colors.green;
      edgeInsets = EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 40);
    }
    else{
      alignment = Alignment.centerLeft;
      nameDisplay = widget.receiverUserDisplayName;
      crossAlign = CrossAxisAlignment.start;
      chatColor = Colors.blue;
      edgeInsets = EdgeInsets.only(top: 10, bottom: 10,right: 40, left: 10);
    }

    return Container(
      alignment: alignment,
      child: Padding(
        padding: edgeInsets,
        child: Column(
          crossAxisAlignment: crossAlign,
          children: [
            Text(
                nameDisplay,
              style: TextStyle(
                fontFamily: "Philosopher",
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2.0),
            ChatBubble(
              chatColor: chatColor,
              message: data['message']
            ),
            Text(
              _dateTimeFromFirebaseTimestamp(data['timestamp']),
              style: TextStyle(
                fontFamily: "Nunito Sans",
                fontSize: 10.0,
                color: Colors.grey,
              ),
            )
          ],
        ),
      )
    );
  }


  Widget _buildMessageInput(){
    return Row(
      children: [
        SizedBox(width: 20),
        Expanded(
          child: TextField(
            controller: _messageController,
            focusNode: focusNode,
            keyboardType: TextInputType.multiline,
            maxLines: 5,
            minLines: 1,
            style: TextStyle(
              fontSize: 16.0
            ),
            onTap: (){
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            },
            decoration: InputDecoration(
              isDense: true,
              hintText: "Say something...",
              hintStyle: TextStyle(color: Colors.grey),
              prefixIcon: IconButton(
                icon: Icon(
                  Icons.image
                ),
                onPressed: (){
                  _sendImage();
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              )
            ),
            obscureText: false,
          )
        ),
        SizedBox(width: 10),
        Padding(
          padding: const EdgeInsets.only(
            bottom: 8,
            left: 2,
            right: 2,
          ),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              color: UsedColor.kPrimaryColor
            ),
            child: IconButton(
                color: Colors.white,
                onPressed: (){
                  sendMessage();
                },
                icon: const Icon(
                  Icons.send,
                  size: 30,
                )
            ),
          ),
        )
      ],
    );
  }

  String _dateTimeFromFirebaseTimestamp(Timestamp firebaseTimestamp) {
    DateTime dateTime = firebaseTimestamp.toDate();
    return DateFormat('HH:mm').format(dateTime);
  }

  void _sendImage() async {
    final _picker = ImagePicker();
    XFile? image;
    final _storage = FirebaseStorage.instance;
    image = await _picker.pickImage(source: ImageSource.gallery);
    if(image == null) return;
    String chatRoom_Id = "${widget.receiverUserID}_${FirebaseAuth.instance.currentUser!.uid}";
    final file = File(image.path);
    String fileName = file.path.split(Platform.pathSeparator).last;
    final path = 'Files/Message/$chatRoom_Id/$fileName';
    var snapshot = await _storage.ref()
        .child(path)
        .putFile(file);
    final downloadURL = await snapshot.ref.getDownloadURL();
    await _chatService.sendMessage(widget.receiverUserID, downloadURL);
  }
}
