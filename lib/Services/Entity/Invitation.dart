import 'package:cloud_firestore/cloud_firestore.dart';

class Invitation{
  final String senderID;
  final String receiverID;
  final String status;
  final Timestamp timestamp;

  Invitation({
    required this.senderID,
    required this.receiverID,
    required this.status,
    required this.timestamp
  });

  Map<String, dynamic> toMap(){
    return{
      'senderID': senderID,
      'receiverID': receiverID,
      'status': status,
      'timestamp': timestamp,
    };
  }

  factory Invitation.fromSnapshot(DocumentSnapshot<Map <String, dynamic>> document){
    final data = document.data()!;
    return Invitation(
        senderID: data['senderID'],
        receiverID: data['receiverID'],
        status: data['status'],
        timestamp: data['timestamp']
    );
  }
}