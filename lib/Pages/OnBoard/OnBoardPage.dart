import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_app/Components/colors.dart';
import 'package:flutter_app/Components/RoundButton.dart';
import 'package:flutter_app/Pages/Home/HomePage.dart';

class OnBoard extends StatefulWidget {
  const OnBoard({super.key});

  @override
  State<OnBoard> createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Stack(
        children: [
          PageView(
            controller: _controller,
            children: [
              //Page 1
              Container(
                color: UsedColor.kPrimaryColor,
                child: Column(
                  children:[
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 60.0, 0, 20.0),
                      child: Text(
                        "Welcome!",
                        style: TextStyle(
                            fontFamily: 'Philosopher',
                            fontSize: 60.0,
                            color: Colors.white
                        ),
                      ),
                    ),
                    SizedBox(height: 50.0),
                    Image.asset('asset/Page2.png'),
                    SizedBox(height: 30),
                    Padding(
                      padding: EdgeInsets.all(50.0),
                      child: Text(
                          "Welcome to STUDY-PTIT, an app made to help connect students!",
                        style: TextStyle(
                          fontFamily: 'Nunito Sans',
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ]
                )
              ),

              //Page 2
              Container(
                color: UsedColor.kSecondaryColor,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 30.0, 0, 0),
                      child: Text(
                        "Connect with friends!",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontFamily: 'Philosopher',
                            fontSize: 50.0,
                            color: Colors.white
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Padding(padding: EdgeInsets.all(4.0),
                        child: Image.asset('asset/Opening_1.jpg')
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "Find friends with the same study goals as you in order to overcome academic challenges!",
                        style: TextStyle(
                          fontFamily: 'Nunito Sans',
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),

              // Page 3
              Container(
                color: UsedColor.kPrimaryColor,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 30.0, 0, 0),
                      child: Text(
                        "Express and discover more about yourself!",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontFamily: 'Philosopher',
                            fontSize: 50.0,
                            color: Colors.white
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    SizedBox(
                        height: 300,
                        width: 300,
                        child: Image.asset('asset/Page3.png')
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: EdgeInsets.all(14.0),
                      child: Text(
                        "To be able to connect easily, you should first set up your profile for everyone to see",
                        style: TextStyle(
                          fontFamily: 'Nunito Sans',
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    RoundButton(
                        btnHeight: 40,
                        btnWidth: 160,
                        descText: "Let's go!",
                        onPressed: () async {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return HomePage();
                          }));
                          final userID = FirebaseAuth.instance.currentUser!.uid;
                          FirebaseFirestore.instance.collection('users').doc(userID).update({
                            'hasSeenOnBoarding': true,
                          });
                        }
                    ),
                  ],
                ),
              ),
            ],
          ),

          Container(
            alignment: Alignment(0, 0.8),
            child: SmoothPageIndicator(
                controller: _controller,
                count: 3,
                effect: WormEffect(
                  activeDotColor: Colors.white,
                  dotHeight: 5.0
                ),
            ),
          )
        ],
      )
    );
  }
}
