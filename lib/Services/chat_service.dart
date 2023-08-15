import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'Entity/Message.dart';
import 'package:flutter_app/Services/Entity/Invitation.dart';


class ChatService extends ChangeNotifier {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String receiverId, String message) async{
    final String currentUserID = _firebaseAuth.currentUser!.uid;
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderID: currentUserID,
      receiverID: receiverId,
      message: message,
      timestamp: timestamp,
    );

    // Generate chatroom ID
    List<String> ids = [currentUserID, receiverId];
    ids.sort();
    String chatRoomID = ids.join("_");
    
    //Add new message 
    await _firebaseFirestore
        .collection('chat_room')
        .doc(chatRoomID)
        .collection('messages')
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(String userID, String otherUserID){
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join("_");

    return _firebaseFirestore
          .collection('chat_room')
          .doc(chatRoomID)
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .snapshots();
  }

  Future<void> sendInvite (String receiverUid) async {
    String currUserID = _firebaseAuth.currentUser!.uid.toString();
    final Timestamp timestamp = Timestamp.now();

    Invitation newInvitation = Invitation(
        receiverID: receiverUid,
        senderID: currUserID,
        status: "Pending",
        timestamp: timestamp
    );

    List<String> ids = [currUserID, receiverUid];
    ids.sort();
    String chatRoomID = ids.join("_");
    await _firebaseFirestore.collection('chat_room').doc(chatRoomID).collection("invitation").add(newInvitation.toMap());

    await _firebaseFirestore.collection('users').
    doc(currUserID).update(
        {'invitationsInfo': FieldValue.arrayUnion([chatRoomID])}
    );

    await _firebaseFirestore.collection('users').
    doc(receiverUid).update(
        {'invitationsInfo': FieldValue.arrayUnion([chatRoomID])}
    );
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getInvitationdata (String chatRoomID) {
    return _firebaseFirestore.collection("chat_room").doc(chatRoomID).collection("invitation").orderBy("timestamp", descending: true).get();
  }

  Future<void> acceptInvite (String chatRoomID) async {
    final inviteData = await _firebaseFirestore.collection("chat_room").doc(chatRoomID).collection("invitation").orderBy("timestamp", descending: true).limit(1).get();
    final doc = inviteData.docs.first;
    Invitation curInvitation = Invitation(
        senderID: doc['senderID'],
        receiverID: doc['receiverID'],
        status: "Accepted",
        timestamp: Timestamp.now()
    );

    await _firebaseFirestore.collection('chat_room').doc(chatRoomID).collection("invitation").add(curInvitation.toMap());

    await _firebaseFirestore.collection('users').
      doc(curInvitation.senderID).update(
        {'friendList': FieldValue.arrayUnion([curInvitation.receiverID])}
    );

    await _firebaseFirestore.collection('users').
    doc(curInvitation.receiverID).update(
        {'friendList': FieldValue.arrayUnion([curInvitation.senderID])}
    );
  }

  Future<void> rejectInvite (String chatRoomID) async{
    final inviteData = await _firebaseFirestore.collection("chat_room").doc(chatRoomID).collection("invitation").orderBy("timestamp", descending: true).limit(1).get();
    final doc = inviteData.docs.first;
    Invitation curInvitation = Invitation(
        senderID: doc['senderID'],
        receiverID: doc['receiverID'],
        status: "Rejected",
        timestamp: Timestamp.now()
    );
    await _firebaseFirestore.collection('chat_room').doc(chatRoomID).collection("invitation").add(curInvitation.toMap());
  }


  Stream<QuerySnapshot> getInviteStream(List<String> InviteIds) {
    return FirebaseFirestore.instance
        .collection('chat_room')
        .where(FieldPath.documentId, whereIn: InviteIds)
        .snapshots();
  }

  Stream<QuerySnapshot> getInvitations(String userId){
      return FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .snapshots()
          .asyncMap((DocumentSnapshot document) async {
        List<String> inviteIds = List<String>.from(document.get('invitationsInfo'));
        return getInviteStream(inviteIds).first; });
  }

  Future<String?> getLastSentMessage (String userID, String otherUserID, String senderName) async{
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join("_");
    return await _firebaseFirestore.collection("chat_room").doc(chatRoomID).collection("messages").orderBy("timestamp", descending: true).get().then(
        (QuerySnapshot query) {
          DocumentSnapshot doc = query.docs.first;
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          if(data.isEmpty){
            return null;
          }
          else{
            String lastMessage;
            if(data['senderID'] == userID){
              lastMessage = "Me: ${data['message']}";
            }
            else {
              lastMessage = "${senderName}: ${data['message']}";
            }
            return lastMessage;
          }
        }
    );
  }
}