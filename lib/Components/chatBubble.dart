import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:photo_view/photo_view.dart';


// CHAT BUBBLE WIDGET

class ChatBubble extends StatelessWidget {
  final Color chatColor;
  final String message;

  const ChatBubble({
    super.key,
    required this.chatColor,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: chatColor,
          borderRadius: BorderRadius.circular(30.0)
        ),
        child: checkIfImage(message) ? GestureDetector(
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
                      imageProvider: NetworkImage(message),
                      maxScale: 2.0,
                      minScale: 0.2,
                    ),
                  );
                }
            );
          },
          child: Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              image: DecorationImage(
                image: NetworkImage(message),
                fit: BoxFit.cover
              )
            ),
          ),
        ) :
        Text(
          message,
          style: TextStyle(
              fontFamily: 'Nunito Sans',
              fontSize: 14.0,
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),
        )
    );
  }

  // CHECK TO SEE IF THIS IS IMAGE FILE
  bool checkIfImage(String message){
    List<String> _image_types = [
      'jpg',
      'jpeg',
      'jfif',
      'pjpeg',
      'pjp',
      'png',
      'svg',
      'gif',
      'apng',
      'webp',
      'avif'
    ];
    try {
      Uri uri = Uri.parse(message);
      String extension = p.extension(uri.path).toLowerCase();
      if (extension.isEmpty) {
        return false;
      }
      extension = extension.split('.').last;
      if (_image_types.contains(extension)) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }
}
