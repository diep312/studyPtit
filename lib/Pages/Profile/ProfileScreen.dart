import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Pages/Profile/updateProfileScreen.dart';
import 'package:flutter_app/Services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/Components/RoundButton.dart';
import 'package:flutter_app/Components/colors.dart';
import 'package:flutter_app/Services/Entity/Profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _currUser = FirebaseAuth.instance.currentUser!;
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(30.0),
            child: Column(
              children: [
                _buildProfile(context),
                const SizedBox(height: 30),
                const Divider(),
                ProfileMenuWidget(
                    title: "My album",
                    icon: Icons.photo_album_outlined,
                    onPressed: (){
                    },
                    textColor: UsedColor.kSecondaryColor
                ),
                ProfileMenuWidget(icon: Icons.book, onPressed: (){}, title: "Rules and disclaimer", textColor: UsedColor.kSecondaryColor,),
                ProfileMenuWidget(icon: Icons.logout, onPressed: (){
                  final authService = Provider.of<AuthService>(context, listen: false);
                  authService.signOut();
                  Navigator.of(context).pushNamed('/');
                }, title: "Sign out", textColor: UsedColor.kSecondaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfile (BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(_currUser.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("User doesn't exist...");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          UserProfile userProfile = UserProfile.fromJson(data);
          return Column(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(data['profilePicURL']),
                  radius: 50,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  data['displayName'],
                  style: TextStyle(
                    fontFamily: "Philosopher",
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                data['email'],
                style: TextStyle(
                    fontFamily: "Nunito Sans",
                    fontSize: 14.0
                ),
              ),
              const SizedBox(height: 30),
              RoundButton(
                  btnHeight: 30,
                  btnWidth: 200,
                  descText: "Update Profile",
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return UpdateProfile(userProfile: userProfile);
                    }));
                  }
              ),
            ],
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}





class ProfileMenuWidget extends StatelessWidget {

  final String title;
  final IconData icon;
  final Function()? onPressed;
  final Color? textColor;

  const ProfileMenuWidget({
    required this.title,
    required this.icon,
    required this.onPressed,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: UsedColor.kPrimaryColor.withOpacity(0.2),
        ),
        child: Icon(icon, color: UsedColor.kSecondaryColor,),
      ),
      title: Text(
          title,
        style: TextStyle(
          fontSize: 14.0,
          fontFamily: "Nunito Sans",
          fontWeight: FontWeight.bold,
          color: textColor
        ),
      ),
      trailing: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.green.withOpacity(0.1),
        ),
        child: const Icon(Icons.arrow_forward, color: Colors.grey),
      ),
    );
  }
}
