import 'package:flutter/material.dart';
import 'package:flutter_app/Pages/Splash.dart';
import 'package:flutter_app/Pages/RegisterPage.dart';
import 'package:flutter_app/Pages/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => LandingPage(),
        '/register': (context) => RegisterPage(),
        '/auth': (context) => AuthPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}


