import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';

class PrimaryTextField extends StatelessWidget {
  final String labelText;
  final Function? onChanged;
  final bool obscureText; // Add the obscureText option
  final TextEditingController? controller;

  const PrimaryTextField({
    required this.labelText,
    this.onChanged,
    this.controller,
    this.obscureText = false, // Set the default value to false
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText, // Pass the obscureText value to the TextField
      decoration: InputDecoration(
        labelText: labelText,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColour),
          borderRadius:
              BorderRadius.circular(15), // Set the border radius to 20
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColour),
          borderRadius:
              BorderRadius.circular(15), // Set the border radius to 20
        ),
        labelStyle: TextStyle(
          color: kPrimaryColour,
        ),
      ),
    );
  }
}
