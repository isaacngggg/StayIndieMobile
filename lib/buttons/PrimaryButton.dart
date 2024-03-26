import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';
// Add any other relevant imports here

enum PrimaryButtonType {
  defaultButton,
  outlinedButton,
  textButton,
}

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final PrimaryButtonType buttonType;

  const PrimaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.buttonType = PrimaryButtonType.defaultButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (buttonType) {
      case PrimaryButtonType.outlinedButton:
        return buildOutlinedButton();
      case PrimaryButtonType.textButton:
        return buildTextButton();
      default:
        return buildDefaultButton();
    }
  }

  Widget buildDefaultButton() {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(vertical: 20.0),
        ),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor: MaterialStateProperty.all<Color>(kPrimaryColour),
        overlayColor: MaterialStateProperty.all<Color>(kPrimaryColour80),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
      child: Container(
        child: Text(
          text,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget buildTextButton() {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(vertical: 20.0),
        ),
        foregroundColor: MaterialStateProperty.all<Color>(kPrimaryColour70),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
        overlayColor: MaterialStateProperty.all<Color>(kPrimaryColour80),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
      child: Container(
        child: Text(
          text,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget buildOutlinedButton() {
    return OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(vertical: 20.0),
        ),
        foregroundColor: MaterialStateProperty.all<Color>(kPrimaryColour),
        overlayColor: MaterialStateProperty.all<Color>(kPrimaryColour20),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
      child: Container(
        child: Text(
          text,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
