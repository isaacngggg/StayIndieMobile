import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';

class PrimarySmallButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const PrimarySmallButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        ),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor: MaterialStateProperty.all<Color>(kPrimaryColour),
        overlayColor: MaterialStateProperty.all<Color>(kPrimaryColour80),
        shape: MaterialStateProperty.all<CircleBorder>(
          CircleBorder(),
        ),
      ),
      child: Container(
        child: Text(
          text,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
