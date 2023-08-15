import 'package:flutter/material.dart';
import 'package:flutter_app/Services/auth_page.dart';


class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);
  @override
  State<LandingPage> createState() => _LandingPage();
}

class _LandingPage extends State<LandingPage>{
  @override

  void initState(){
    super.initState();
    _navigatehome();
  }

  _navigatehome() async{
    await Future.delayed(Duration(milliseconds: 2500), () {});
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
                height: 230,
                width: 230,
                child: Image.asset(
                  'asset/Logo.png',
                  fit: BoxFit.fill,
                )
            ),
            SizedBox(height: 30),
            Text(
                'COSTUDY',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 50.0,
                  fontFamily: 'Nunito Sans',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 8
                )
            ),
            SizedBox(height: 10),
            Text(
              'LEARN TOGETHER',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20.0,
                fontFamily: 'Nunito Sans',
                letterSpacing: 4,
                fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ),
    );
  }
}