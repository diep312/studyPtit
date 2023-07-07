import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Components/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  void signUserOut(){
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(
          onPressed: signUserOut,
          icon: Icon(Icons.exit_to_app_rounded),
        )],
        title: Text(
          'Home',
          style: TextStyle(
            fontFamily: 'Philosopher',
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: appcolors.shade400,
          ),
        ),
        backgroundColor: appcolors.shade700,
      ),
      body: Center(
        child: Text("LOGGED IN AS ${user.email!}"),
      ),
    );
  }
}
