import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Components/colors.dart';
import 'package:flutter_app/Pages/Home/Home.dart';
import 'package:flutter_app/Pages/Message/MessageScreen.dart';
import 'package:flutter_app/Pages/Profile/ProfileScreen.dart';
import 'package:flutter_app/Pages/Notification/Notification.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  List pages = [
    HomeScreen(),
    MessageScreen(),
    NotificationPage(),
    ProfileScreen()
  ];
  void signUserOut(){
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 14,
        backgroundColor: Colors.white,
        currentIndex: currentIndex,
        selectedItemColor: UsedColor.kSecondaryColor,
        unselectedItemColor: UsedColor.kComplementColor,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        onTap: (index) => setState(() {
          currentIndex = index;
        }),
        items: [
          BottomNavigationBarItem(
              label: "Home",
              icon: Icon(Icons.home)
          ),
          BottomNavigationBarItem(
              label: "Messages",
              icon: Icon(Icons.comment)
          ),
          BottomNavigationBarItem(
              label: "Requests",
              icon: Icon(Icons.notifications)
          ),
          BottomNavigationBarItem(
              label: "My Profile",
              icon: Icon(Icons.account_circle_rounded)
          ),
        ],
      ),
    );
  }
}
