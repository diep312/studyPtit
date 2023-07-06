import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final double btnHeight;
  final double btnWidth;
  final Function()? onPressed;
  final String descText;
  const RoundButton({
    super.key,
    required this.btnHeight,
    required this.btnWidth,
    required this.descText,
    required this.onPressed
});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: btnWidth,
      height: btnHeight,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(90),
              )
          ),
          onPressed: onPressed,
          child: Center(
              child: Text(
                descText,
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'Philosopher',
                  fontWeight: FontWeight.bold,
                ),
              )
          )
      ),
    );
  }
}
