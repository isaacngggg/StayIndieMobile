import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stay_indie/models/Project.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stay_indie/models/Profile.dart';
import 'package:stay_indie/models/connections/Spotify/Spotify.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum FormInputFieldType { text, number, date, media, grid }

const kIsWeb = false;

final supabase = Supabase.instance.client;

final Spotify spotify = Spotify();
const Uuid uuid = Uuid();

String currentUserId = supabase.auth.currentUser != null
    ? supabase.auth.currentUser!.id.toString()
    : '1';

late Profile currentUserProfile;

ThemeData theme = ThemeData.dark().copyWith(
  textTheme: GoogleFonts.dmSansTextTheme(
    ThemeData.dark().textTheme,
  ),
  colorScheme: ColorScheme.dark(
      primary: kPrimaryColour,
      secondary: kPrimaryColour90,
      tertiary: kAccentColour),
  primaryColor: kAccentColour,
  scaffoldBackgroundColor: kBackgroundColour,
  highlightColor: kAccentColour,
  appBarTheme: AppBarTheme(
    iconTheme: IconThemeData(color: Colors.white), // if you want black icons
    elevation: 0,
    backgroundColor: kBackgroundColour,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.transparent,
    selectedIconTheme: IconThemeData(color: kPrimaryColour),
    selectedItemColor: kPrimaryColour,
    unselectedItemColor: kPrimaryColour80,
  ),
);

// Colors

const Color kPrimaryColour = Color(0xFFFAFAFA);
const Color kPrimaryColour20 = Color(0xFFf5f5f5);
const Color kPrimaryColour30 = Color(0xFFe0e0e0);
const Color kPrimaryColour40 = Color(0xFfcccccccc);
const Color kPrimaryColour50 = Color(0xFFb3b3b3);
const Color kPrimaryColour60 = Color(0xFF999999);
const Color kPrimaryColour70 = Color(0xFF808080);
const Color kPrimaryColour80 = Color(0xFF666666);
const Color kPrimaryColour90 = Color(0xFF313131);

const Color kBackgroundColour = Color(0xFF0D0D0D);
const Color kBackgroundColour10 = Color(0xFF181818);
const Color kBackgroundColour20 = Color(0xFF212121);
const Color kBackgroundColour30 = Color(0xFF333333);

Color kAccentColour = Color(0xFF81C657);
Color kAccentColour10 = Color(0xFFC6EAB0);
Color kAccentColour20 = Color(0xFFE6F4D6);

const Color kTransparent = Color(0x00000000);

// Button Styles

// Large Buttons

ButtonStyle kPrimaryButtonStyle = ButtonStyle(
  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
    EdgeInsets.symmetric(vertical: 20.0),
  ),
  foregroundColor: MaterialStateProperty.all<Color>(kBackgroundColour),
  backgroundColor: MaterialStateProperty.all<Color>(kPrimaryColour),
  overlayColor: MaterialStateProperty.all<Color>(kPrimaryColour80),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
  ),
);

ButtonStyle kOutlinedButtonStyle = ButtonStyle(
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
);

ButtonStyle kTextButtonStyle = ButtonStyle(
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
);

ButtonStyle kSecondaryButtonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.all(kAccentColour10),
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
);

// Small Buttons

ButtonStyle kSmallPrimaryButtonStyle = ButtonStyle(
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      side: BorderSide(color: kBackgroundColour20, width: 1),
      borderRadius: BorderRadius.circular(13.0),
    ),
  ),
  foregroundColor: MaterialStateProperty.all<Color>(kBackgroundColour),
  backgroundColor: MaterialStateProperty.all<Color>(kPrimaryColour),
);

ButtonStyle kSmallSecondaryButtonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.all(kBackgroundColour20),
  foregroundColor: MaterialStateProperty.all(kPrimaryColour20),
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
);

ButtonStyle kSmallDisableButton = ButtonStyle(
  backgroundColor: MaterialStateProperty.all(kPrimaryColour50),
  foregroundColor: MaterialStateProperty.all(kBackgroundColour),
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
);

ButtonStyle kSmallAccentButtonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.all(kAccentColour),
  foregroundColor: MaterialStateProperty.all(kBackgroundColour20),
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
);

ButtonStyle kSmallDeleteButton = ButtonStyle(
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(13.0),
      side: BorderSide(color: kPrimaryColour20, width: 1),
    ),
  ),
  foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
  backgroundColor: MaterialStateProperty.all<Color>(Colors.red.shade100),
);

// Input Fields

BoxDecoration kMultiInputBoxDecoraction = BoxDecoration(
  border: Border.all(color: kPrimaryColour50, width: 2),
  borderRadius: BorderRadius.circular(15),
);

Divider kDivider = Divider(
  height: 1,
  color: kPrimaryColour80,
  thickness: 1,
);

InputDecoration kPlainTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
  border: InputBorder.none,
  labelStyle: TextStyle(
    color: kPrimaryColour,
  ),
);

InputDecoration kBoxedTextFieldDecoration = InputDecoration(
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: kPrimaryColour50),
      borderRadius: BorderRadius.circular(15),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: kPrimaryColour50),
      borderRadius: BorderRadius.circular(15),
    ),
    labelStyle: TextStyle(
      color: kPrimaryColour80,
    ),
    floatingLabelBehavior: FloatingLabelBehavior.never);

InputDecoration kGreyTextFieldDecoration = InputDecoration(
  fillColor: kBackgroundColour10,
  focusColor: kPrimaryColour20,
  filled: true,
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kPrimaryColour50),
    borderRadius: BorderRadius.circular(15),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kPrimaryColour50),
    borderRadius: BorderRadius.circular(15),
  ),
  floatingLabelBehavior: FloatingLabelBehavior.auto,
  floatingLabelAlignment: FloatingLabelAlignment.start,
);

InputDecoration kLinedTextFieldDecoration = InputDecoration(
  labelStyle: kSubheading1.copyWith(
      fontFamily: GoogleFonts.ebGaramond().fontFamily, color: kPrimaryColour),
  floatingLabelBehavior: FloatingLabelBehavior.never,
);

InputDecoration kSearchTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.all(5),
  border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(Radius.circular(15))),
  filled: true,
  fillColor: kBackgroundColour20,
  hintText: 'Search contacts or username',
  prefixIcon: Icon(Icons.search),
);

// Text Styles

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
  fontSize: 18,
  fontWeight: FontWeight.bold,
);

TextStyle kHeading4 = TextStyle(
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
  color: kBackgroundColour10,
  border: kOutlineLight,
  borderRadius: BorderRadius.all(Radius.circular(20)),
);

BoxDecoration kSelectedOutlineBorder = BoxDecoration(
  border: kOutlineBold,
  borderRadius: BorderRadius.all(Radius.circular(20)),
);

Border kOutlineLight = Border.all(color: kPrimaryColour90, width: 1);

Border kOutlineBold = Border.all(color: kPrimaryColour90, width: 2);

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

class NoAnimationRoute<T> extends MaterialPageRoute<T> {
  NoAnimationRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
  }) : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}

// Preloader
final preloader = Scaffold(
  body: Center(
    child: LoadingAnimationWidget.hexagonDots(
      color: kPrimaryColour,
      size: 30,
    ),
  ),
);

void clearAllCache(context) {
  try {
    currentUserId = supabase.auth.currentUser!.id.toString();
    Profile.removeProfileFromPrefs();
    Profile.clearCache();
    Project.clearCache();

    print('Cache Cleared');
    // ShowSnackBar(context)
    //     .showSnackBar(message: 'Cache Cleared', backgroundColor: Colors.green);
  } catch (e) {
    ShowSnackBar(context).showSnackBar(
        message: 'Cache unable to be clear: ' + e.toString(),
        backgroundColor: Colors.red);
  }
}
