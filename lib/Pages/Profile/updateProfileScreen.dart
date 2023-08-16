import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Components/colors.dart';
import 'package:flutter_app/Components/usersAlbumView.dart';
import 'package:flutter_app/Services/getUserService.dart';
import 'package:image_picker/image_picker.dart';
import '../../Components/RoundButton.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/Services/Entity/Profile.dart';


class UpdateProfile extends StatefulWidget {
  final UserProfile userProfile;
  const UpdateProfile({
    super.key,
    required this.userProfile
  });
  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  // CONTROLLERS FOR WIDGET
  final dateOfBirth = TextEditingController();
  final majorController = TextEditingController();
  final contactController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final scrollController = ScrollController(); 
  final GetUserService _getUserService = GetUserService();


  // INITIALIZE THE USER'S INFO
  @override
  void initState() {
    super.initState();
    descController.text = widget.userProfile.briefDescription!;
    dateOfBirth.text = widget.userProfile.birthday == null ?  "" : widget.userProfile.birthday!;
    majorController.text = widget.userProfile.major == null ? "" : widget.userProfile.major!;
    contactController.text = widget.userProfile.contact == null ? "" : widget.userProfile.contact!;
  }

  // CHECK IF ANY FIELD IS EMPTY
  bool checkEmpty() =>
      dateOfBirth.text.isNotEmpty
      && majorController.text.isNotEmpty
      && contactController.text.isNotEmpty;

  // CHECK IF THE DESCRIPTION IS SELECTED
  bool checkDesc = false;
  // CHECK IF THERES ANY CHANGES
  bool showBtn = false;

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
          controller: scrollController,
          child: Column(
            children: [
              // Profile Picture with Edit button
              Stack(
                children: [
                 Container(
                   height: 160,
                   width: MediaQuery.of(context).size.width,
                   decoration: BoxDecoration(
                     image: DecorationImage(
                       image: NetworkImage(widget.userProfile.imageURL),
                       fit: BoxFit.fitWidth,
                     ),
                   ),
                 ),
                  Container(
                    height: 160,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
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
                      top: 5,
                      right: 5,
                      child: Container(
                        alignment: Alignment.center,
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: UsedColor.kSecondaryColor),
                        child: IconButton(
                            onPressed: () => _uploadPhotos(),
                            icon: const Icon(
                                Icons.edit,
                                color: UsedColor.kComplementColor,
                                size: 20
                            ),
                        ),
                      )
                    ),
                  Positioned(
                    bottom: 5,
                    left: 5,
                    child: Text(
                      widget.userProfile.userName,
                      style: TextStyle(
                        fontFamily: "Philosopher",
                        fontSize: 32,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10.0),
             
             // DESCRIPTION CARD
             Padding(
               padding: EdgeInsets.all(8),
               child: Container(
                 padding: EdgeInsets.all(20),
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.all(Radius.circular(20)),
                   color: UsedColor.kThirdSecondaryColor,
                 ),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         const Text(
                           "Description",
                           style: TextStyle(
                             fontFamily: "Philosopher",
                             fontSize: 24.0,
                             color: Colors.black,
                           ),
                         ),
                         checkDesc ? Container(
                           alignment: Alignment.center,
                           width: 30,
                           height: 30,
                           decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: UsedColor.kSecondaryColor),
                           child: IconButton(
                             onPressed: () async {
                               if(descController.text.isNotEmpty){
                                 await FirebaseFirestore.instance.collection("users")
                                     .doc(FirebaseAuth.instance.currentUser!.uid).update(
                                     {
                                       'briefDesc' : descController.text
                                     }
                                 );
                               }
                               if(context.mounted){
                                 ScaffoldMessenger.of(context).showSnackBar(
                                   const SnackBar(
                                     content: Text('Updated!'),
                                   ),
                                 );
                               }
                               setState(() {
                               });
                             },
                             icon: const Icon(
                                 Icons.check,
                                 color: UsedColor.kComplementColor,
                                 size: 15
                             ),
                           ),
                         ) : Container(),
                       ],
                     ),
                     const SizedBox(height: 10),
                     TextField(
                       minLines: 1,
                       maxLines: 12,
                       keyboardType: TextInputType.multiline,
                       controller: descController,
                       onTap: (){
                         descController.clear();
                         scrollController.animateTo(0.5, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                       },
                       onChanged: (controller){
                         if(controller.isNotEmpty){
                           setState(() {
                             checkDesc = true;
                           });
                         }
                         else{
                           setState(() {
                             checkDesc = false;
                           });
                         }
                       },
                       decoration: InputDecoration(
                           border: OutlineInputBorder(
                               borderRadius: BorderRadius.all(Radius.circular(10))
                           )
                       ),
                     ),
                   ],
                 ),
               ),
             ),
              const SizedBox(height: 10.0),

              // Additional info Widget

              Padding(
                padding: EdgeInsets.all(8),
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: UsedColor.kThirdSecondaryColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Additional Info",
                        style: TextStyle(
                          fontFamily: "Philosopher",
                          fontSize: 24.0,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Form(
                        onChanged: (){
                          setState(() {
                            checkEmpty();
                            showBtn = true;
                          });
                        },
                        child: Column(
                          children: [
                            TextFormField(
                              controller: dateOfBirth,
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                ).then((date) {
                                  setState(() {
                                    dateOfBirth.text = DateFormat('dd-MM-yyyy').format(date!);
                                  });
                                });
                              },
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
                              controller: majorController,
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
                            SizedBox(height: 20),
                            TextFormField(
                              controller: contactController,
                              decoration: InputDecoration(
                                  label: Text("Contact"),
                                  prefixIcon: Icon(Icons.link),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
                                  prefixIconColor: UsedColor.kSecondaryColor,
                                  floatingLabelStyle: TextStyle(color: UsedColor.kPrimaryColor),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2, color: UsedColor.kSecondaryColor),
                                  )
                              ),
                            ),
                            SizedBox(height: 20),
                            checkEmpty() ? Container() : Text("Please fill in all the missing area!", style: TextStyle(color: Colors.red, fontFamily: "Nunito Sans")),
                            SizedBox(height: 20),
                            showBtn ? RoundButton(
                              btnWidth: 120,
                              btnHeight: 40,
                              descText: "Update",
                              onPressed: (){
                                if(checkEmpty()){
                                  _getUserService.updateProfile(dateOfBirth, majorController, contactController);
                                  showDialog(
                                      context: context,
                                      builder: (context){
                                        return AlertDialog(
                                          title: Text('Profile Updated'),
                                          content: Text('Your profile has been updated successfully!'),
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('OK'),
                                            ),
                                          ],
                                        );
                                      }
                                  );
                                }
                                else{
                                  setState(() {
                                    checkEmpty();
                                  });
                                }
                              },
                            ) : Container(),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),

              // PICTURES OF USER
              Stack(
                children: [
                  userAlbumList(userUID: widget.userProfile.uid),
                  Positioned(
                      top: 15,
                      right: 15,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          color: UsedColor.kThirdSecondaryColor,
                        ),
                        child: IconButton(
                          onPressed: (){
                            uploadPictureToAlbum();
                          },
                          icon: Icon(
                              Icons.add,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      )
                  )
                ],
              ),

            ],
          ),
        )
      )
    );
  }

  // UPLOAD IMAGE FUNCTION
  void _uploadPhotos() async {
    final _picker = ImagePicker();
    XFile? image;
    final _storage = FirebaseStorage.instance;
    image = await _picker.pickImage(source: ImageSource.gallery);
    if(image == null) return;
    if(context.mounted){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Loading...'),
        ),
      );
    }

    final file = File(image.path);
    final path = 'Files/UsersProfilePicture/${FirebaseAuth.instance.currentUser!.uid}';
    var snapshot = await _storage.ref()
        .child(path)
        .putFile(file);

    final downloadURL = await snapshot.ref.getDownloadURL();
    await FirebaseFirestore.instance.collection('users').doc(widget.userProfile.uid).update({
        'profilePicURL' : downloadURL
    });

    setState(() {
    });

    if(context.mounted){
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
    setState(() {

    });
  }

  // Add picture to album
  void uploadPictureToAlbum() async{
    final _picker = ImagePicker();
    XFile? image;
    final _storage = FirebaseStorage.instance;
    image = await _picker.pickImage(source: ImageSource.gallery);
    if(image == null) return;
    if(context.mounted){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Loading...'),
        ),
      );
    }

    final file = File(image.path);
    String fileName = file.path.split(Platform.pathSeparator).last;
    final path = 'Files/UsersAlbum/${FirebaseAuth.instance.currentUser!.uid}/${fileName}';
    var snapshot = await _storage.ref()
        .child(path)
        .putFile(file);

    final downloadURL = await snapshot.ref.getDownloadURL();
    await FirebaseFirestore.instance.collection('users').doc(widget.userProfile.uid).collection("albumPics").add({
      'pictureURL' : downloadURL,
      'time' : Timestamp.now()
    });

    if(context.mounted){
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }
}
