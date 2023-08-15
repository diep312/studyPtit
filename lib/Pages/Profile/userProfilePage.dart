import 'package:flutter/material.dart';
import 'package:flutter_app/Components/colors.dart';
import 'package:flutter_app/Services/Entity/Profile.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_app/Components/PanelWidget.dart';


class UserProfilePage extends StatefulWidget {
  final UserProfile userProfile;
  const UserProfilePage({
    super.key,
    required this.userProfile,
  });

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SlidingUpPanel(
          minHeight: MediaQuery.of(context).size.height * 0.25,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          parallaxEnabled: true,
          parallaxOffset: 0.3,
          body: Stack(
            children: [

              Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(widget.userProfile.imageURL)
                )
              ),
            ),   Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      UsedColor.kSecondaryColor,
                      Color.fromARGB(0, 0, 0, 0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
              ),
            ),
            ]
          ),
          panelBuilder: (controller) => PanelWidget(
            controller: controller,
            userProfile: widget.userProfile,
          ),
        ),
          Container(
            height: 70,
            child: AppBar(
              elevation: 0,
              backgroundColor: Color.fromARGB(0, 0, 0, 0),
              leading: IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios_rounded),
              ),
            ),
          ),
        ]
      )
    );
  }

}
