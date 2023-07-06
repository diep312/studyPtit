import 'package:flutter/material.dart';
import '../colors.dart';

class InputTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final String descText;
  final bool obscureText;

  const InputTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.descText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 40.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              hintText,
              style: TextStyle(
                fontFamily: 'Nunito Sans',
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            TextField(
              controller: controller,
              obscureText: obscureText,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(20),
                ),
                fillColor: appcolors.shade50,
                filled: true,
                hintText: descText,
                hintStyle: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black26,
                )
              ),
            ),
          ]
      ),
    );
  }
}

