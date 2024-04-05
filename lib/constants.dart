import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:google_fonts/google_fonts.dart';

enum FormInputFieldType { text, number, date, media }

const kIsWeb = false;

final supabase = Supabase.instance.client;

const Uuid uuid = Uuid();

String currentUserId = supabase.auth.currentUser != null
    ? supabase.auth.currentUser!.id.toString()
    : '1';

Color kPrimaryColour = Colors.grey.shade900;

Color kPrimaryColour80 = Colors.grey.shade800;
Color kPrimaryColour70 = Colors.grey.shade700;
Color kPrimaryColour60 = Colors.grey.shade600;
Color kPrimaryColour50 = Colors.grey.shade500;
Color kPrimaryColour40 = Colors.grey.shade400;
Color kPrimaryColour20 = Colors.grey.shade200;

Color kBackgroundColour = Colors.white;

Color kAccentColour = Colors.deepPurple.shade400;
Color kAccentColour20 = Colors.deepPurple.shade200;
Color kAccentColour10 = Colors.deepPurple.shade100.withAlpha(50);

ButtonStyle kSecondaryButtonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.all(kAccentColour10),
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
);

ButtonStyle kWiredButtonSmall = ButtonStyle(
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(13.0),
      side: BorderSide(color: kPrimaryColour20, width: 1),
    ),
  ),
  foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
  backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
);

ButtonStyle kDeleteButtonSmall = ButtonStyle(
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(13.0),
      side: BorderSide(color: kPrimaryColour20, width: 1),
    ),
  ),
  foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
  backgroundColor: MaterialStateProperty.all<Color>(Colors.red.shade100),
);

ButtonStyle kPrimaryButtonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.all(kAccentColour),
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25),
    ),
  ),
);

ButtonStyle kPrimaryButtonSmall = ButtonStyle(
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(13.0),
    ),
  ),
  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
  backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
);

const preloader =
    Center(child: CircularProgressIndicator(color: Colors.deepPurpleAccent));

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

BoxDecoration kSelectedOutlineBorder = BoxDecoration(
  border: kOutlineBold,
  borderRadius: BorderRadius.all(Radius.circular(10)),
);

Border kOutlineLight = Border.all(color: kPrimaryColour20, width: 1);

Border kOutlineBold = Border.all(color: kPrimaryColour, width: 2);

extension ShowSnackBar on BuildContext {
  /// Displays a basic snackbar
  void showSnackBar({
    required String message,
    Color backgroundColor = Colors.white,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    ));
  }

  /// Displays a red snackbar indicating error
  void showErrorSnackBar({required String message}) {
    showSnackBar(message: message, backgroundColor: Colors.red);
  }
}

const formSpacer = SizedBox(width: 16, height: 16);

/// Some padding for all the forms to use
const formPadding = EdgeInsets.symmetric(vertical: 20, horizontal: 16);
