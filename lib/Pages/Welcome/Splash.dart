import 'package:flutter/material.dart';
import 'package:flutter_app/Components/colors.dart';
import 'package:flutter_app/Services/auth_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);
  @override
  _splash createState() => _splash();
}

class _splash extends State<LandingPage>{
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
      backgroundColor: appcolors.shade800,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
                height: 290,
                width: 290,
                child: Image.asset(
                  'asset/Logo.png',
                  fit: BoxFit.cover,
                )
            ),
            Text(
                'StudyPTIT',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 60.0,
                  fontFamily: 'Philosopher',
                  fontWeight: FontWeight.bold,
                )
            ),
            Text(
              'Exchange - Explain - Exceed',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontFamily: 'Nunito Sans',
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(
              height: 50.0,
            )
          ],
        ),
      ),
    );
  }
}