import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:photo_view/photo_view.dart';


class userAlbumList extends StatefulWidget {
  final String userUID; 
  const userAlbumList({
    super.key,
    required this.userUID,
  });
  @override
  State<userAlbumList> createState() => _userAlbumListState();
}

class _userAlbumListState extends State<userAlbumList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users')
            .doc(widget.userUID).collection('albumPics').snapshots(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  const Text(
                    "Pictures",
                    style: TextStyle(
                      fontFamily: "Philosopher",
                      fontSize: 24.0,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildAlbumPicture(snapshot.data!),
                ],
              ),
            );
          }
          if(snapshot.hasError){
            return Text("Something went wrong...");
          }
          return Text("Nothing...");
        }
    );
  }

  Widget _buildAlbumPicture(QuerySnapshot<Map<String, dynamic>> query){
    List<String> imagesInAlbum = [];
    for(var doc in query.docs){
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      imagesInAlbum.add(data['pictureURL']);
    }

    if(imagesInAlbum.isEmpty){
      return Text("No pictures found..");
    }
    else{
      return Container(
        height: 250,
        width: MediaQuery.of(context).size.width,
        child: ScrollSnapList(
          itemSize: 150,
          onItemFocus: (index){},
          itemBuilder: (context, index){
            return GestureDetector(
              onTap: (){
                showDialog(
                    context: context,
                    builder: (context){
                      return Scaffold(
                        appBar:  AppBar(
                          elevation: 0,
                          backgroundColor: Colors.black,
                          leading: IconButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.close),
                          ),
                        ),
                        body: PhotoView(
                          imageProvider: NetworkImage(imagesInAlbum[index]),
                          maxScale: 2.0,
                          minScale: 0.2,
                        ),
                      );
                    }
                );
              },
              child: Container(
                height: 200,
                width: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    image: DecorationImage(
                        image: NetworkImage(imagesInAlbum[index]),
                        fit: BoxFit.cover
                    )
                ),
              ),
            );
          },
          itemCount: imagesInAlbum.length,
          scrollDirection: Axis.horizontal,
        ),
      );
    }
  }
}
