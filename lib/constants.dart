import 'package:flutter/material.dart';

const kIsWeb = false;

Color kPrimaryColour = Colors.grey.shade900;

Color kPrimaryColour80 = Colors.grey.shade800;
Color kPrimaryColour70 = Colors.grey.shade700;
Color kPrimaryColour60 = Colors.grey.shade600;
Color kPrimaryColour50 = Colors.grey.shade500;
Color kPrimaryColour40 = Colors.grey.shade400;
Color kPrimaryColour20 = Colors.grey.shade200;

Color kBackgroundColour = Colors.white;

Color kAccentColour = Colors.purple.shade600;

TextStyle kButtonTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
);

TextStyle kHeading1 = TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.bold,
);

TextStyle kHeading2 = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
);

TextStyle kHeading3 = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.bold,
);

TextStyle kSubheading1 = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.normal,
);

TextStyle kSubheading2 = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.normal,
);

TextStyle kSubheading3 = TextStyle(
  fontSize: 10,
  fontWeight: FontWeight.normal,
);

TextStyle kBody1 = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.normal,
);

TextStyle kBody2 = TextStyle(
  fontSize: 10,
  fontWeight: FontWeight.normal,
);

TextStyle kCaption1 = TextStyle(
  fontSize: 10,
  fontWeight: FontWeight.normal,
);

BoxDecoration kOutlineBorder = BoxDecoration(
  border: kOutlineLight,
  borderRadius: BorderRadius.all(Radius.circular(10)),
);

Border kOutlineLight = Border.all(color: kPrimaryColour20, width: 1);
