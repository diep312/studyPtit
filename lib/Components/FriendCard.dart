import 'package:flutter/material.dart';
import 'package:flutter_app/Pages/Profile/userProfilePage.dart';
import 'package:flutter_app/Services/Entity/Profile.dart';
import 'package:flutter_app/Services/chat_service.dart';

class FriendCard extends StatefulWidget {
  final UserProfile userProfile;

  const FriendCard({
    super.key,
    required this.userProfile
  });
  @override
  State<FriendCard> createState() => _FriendCardState();
}

class _FriendCardState extends State<FriendCard> {
  ChatService chatService = ChatService();

  void goToProfile(){
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserProfilePage(userProfile: widget.userProfile),
        )
    );
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: goToProfile,
      child: Container(
        width: 320,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(widget.userProfile.imageURL),
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  spreadRadius: 8,
                  blurRadius: 8,
                  offset: Offset(3, 3)
               )],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                    colors: [
                  Color.fromARGB(200, 0, 0, 0),
                  Color.fromARGB(50, 0, 0, 0),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                )
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(
                      widget.userProfile.userName,
                      style: TextStyle(
                        fontFamily: 'Philosopher',
                        fontSize: 28.0,
                        color: Colors.white,
                      ),
                    ),
                      Text(
                        widget.userProfile.major!,
                        style: TextStyle(
                          fontFamily: "Nunito Sans",
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  Text(
                    widget.userProfile.briefDescription!,
                    style: TextStyle(
                        fontFamily: "Nunito Sans",
                        color: Colors.white,
                        fontSize: 14.0,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
