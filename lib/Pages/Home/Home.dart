import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_app/Components/FriendCard.dart';
import 'package:flutter_app/Components/colors.dart';
import 'package:flutter_app/Services/Entity/Profile.dart';
import 'package:flutter_app/Services/getUserService.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GetUserService _getUserService = GetUserService();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              color: UsedColor.kPrimaryColor,
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(30), bottomLeft: Radius.circular(30))
            ),
          ),
          Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(30, 50, 0, 0),
                child: Text(
                  "Discover",
                  style: TextStyle(
                    fontFamily: "Philosopher",
                    fontSize: 36.0,
                    fontWeight: FontWeight.bold,
                    color: UsedColor.kThirdSecondaryColor,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              _buildUserCards()
          ]
        ),

        ]
      ),
    );
  }

  Widget _buildUserCards(){
    return StreamBuilder(
      stream: _getUserService.getUserList(),
      builder: (context, snapshot){
        if(snapshot.hasError){
          return const Text("Error");
        }

        if(snapshot.connectionState == ConnectionState.waiting){
          return const CircularProgressIndicator();
        }

        //RANDOMIZE CARDS
        List<DocumentSnapshot> docs = [];
        for (QueryDocumentSnapshot doc in snapshot.data!.docs) {
          docs.add(doc);
        }
        docs.shuffle();

        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 1.4,
          child: ScrollSnapList(
              itemBuilder:(context, index) => _buildUserCardItem(docs[index]),
              itemCount: snapshot.data!.size,
              itemSize: 320,
              onItemFocus: (index) {
              },
              dynamicItemSize: true,
              curve: Curves.easeInOut,
           )
          );
      }
    );
  }

  Widget _buildUserCardItem(DocumentSnapshot document){
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    return FriendCard(userProfile: UserProfile.fromJson(data));
  }

}


