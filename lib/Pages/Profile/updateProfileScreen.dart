import 'package:flutter/material.dart';
import 'package:flutter_app/Components/colors.dart';
import '../../Components/RoundButton.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: UsedColor.kPrimaryColor,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
        title: const Text(
            "Update Profile",
          style: TextStyle(
            fontFamily: "Philosopher",
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          )
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage('https://as2.ftcdn.net/v2/jpg/03/64/21/11/1000_F_364211147_1qgLVxv1Tcq0Ohz3FawUfrtONzz8nq3e.jpg'),
                      radius: 50,
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          alignment: Alignment.center,
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: UsedColor.kSecondaryColor),
                          child: IconButton(
                              onPressed: (){},
                              icon: const Icon(
                                  Icons.edit,
                                  color: UsedColor.kComplementColor,
                                  size: 20
                              ),
                          ),
                        )
                      ),

                  ],
                ),
                const SizedBox(height: 10.0),
                TextButton(
                    onPressed: (){
                    },
                    child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Text('About me...', style: TextStyle(fontFamily: 'Nunito Sans', fontSize: 20.0, color: Colors.blueAccent, fontWeight: FontWeight.bold)))
                ),
                const SizedBox(height: 40.0),
                Form(
                  child: Column(
                    children: [
                      //Name
                      TextFormField(
                        decoration: InputDecoration(
                          label: Text("Name"),
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
                          prefixIconColor: UsedColor.kSecondaryColor,
                          floatingLabelStyle: TextStyle(color: UsedColor.kPrimaryColor),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: UsedColor.kSecondaryColor),
                          )
                        ),
                      ),
                      SizedBox(height: 20),
                      //Date of Birth
                      TextFormField(
                        decoration: InputDecoration(
                            label: Text("Date of Birth"),
                            prefixIcon: Icon(Icons.access_time_filled_outlined),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
                            prefixIconColor: UsedColor.kSecondaryColor,
                            floatingLabelStyle: TextStyle(color: UsedColor.kPrimaryColor),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2, color: UsedColor.kSecondaryColor),
                            )
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                            label: Text("Major"),
                            prefixIcon: Icon(Icons.abc_rounded),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
                            prefixIconColor: UsedColor.kSecondaryColor,
                            floatingLabelStyle: TextStyle(color: UsedColor.kPrimaryColor),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2, color: UsedColor.kSecondaryColor),
                            )
                        ),
                      ),
                      SizedBox(height: 50),
                      RoundButton(
                        btnWidth: 120,
                        btnHeight: 40,
                        descText: "Update",
                        onPressed: (){},
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      )
    );
  }
}
