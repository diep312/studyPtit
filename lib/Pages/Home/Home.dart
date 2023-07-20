import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Components/DragWidget.dart';
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
      color: UsedColor.kThirdSecondaryColor,
      child: SafeArea(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 350,
              decoration: const ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(64),
                    bottomRight: Radius.circular(64)
                  )
                ),
                color: UsedColor.kSecondaryColor
              ),
            ),
            Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.fromLTRB(40.0, 20, 0, 0),
                  child: Text(
                    "Discover",
                    style: TextStyle(
                      fontFamily: "Philosopher",
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      color: UsedColor.kThirdSecondaryColor,
                    ),
                  ),
                ),
                SizedBox(height: 30.0),
                _buildUserCards()
            ]
          ),]
        ),
      ),
    );
  }

  Widget _buildUserCards(){
    ValueNotifier<Swipe> swipeNotifier = ValueNotifier(Swipe.none);
    return StreamBuilder(
      stream: _getUserService.getUserList(),
      builder: (context, snapshot){
        if(snapshot.hasError){
          return const Text("Error");
        }

        if(snapshot.connectionState == ConnectionState.waiting){
          return const CircularProgressIndicator();
        }

        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 1.4,
          child: ScrollSnapList(
              itemBuilder:(context, index) => _buildUserCardItem(snapshot.data!.docs[index]),
              itemCount: snapshot.data!.size,
              itemSize: MediaQuery.of(context).size.width + 30,
              onItemFocus: (index) {},
              dynamicItemSize: true,
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



