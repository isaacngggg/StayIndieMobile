import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';
import 'package:stay_indie/screens/journeys/add_journey_screen.dart';
import 'package:stay_indie/screens/archive/AddScreen.dart';
import 'package:stay_indie/screens/chat/InboxScreen.dart';
import 'package:stay_indie/screens/archive/ConnectionsScreen.dart';
import 'package:stay_indie/screens/archive/OpportunitiesScreen.dart';
import 'package:stay_indie/screens/archive/HomeScreen.dart';
import 'package:stay_indie/screens/connections_page.dart';
import 'package:stay_indie/screens/loginSignUpFlow/SplashScreen.dart';
import 'package:stay_indie/screens/project/manage_story_screen.dart';

import 'package:stay_indie/screens/loginSignUpFlow/LoginScreen.dart';
import 'package:stay_indie/screens/loginSignUpFlow/SignUpScreen.dart';
import 'package:stay_indie/screens/welcome/IndustryScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:stay_indie/screens/loginSignUpFlow/testLoginPage.dart';
import 'package:stay_indie/screens/loginSignUpFlow/testRegisterPage.dart';
import 'package:stay_indie/screens/profile/MainProfilePage.dart';
import 'package:stay_indie/screens/settings/settings_page.dart';
import 'package:stay_indie/screens/profile/profile_edit_page.dart';
import 'package:stay_indie/screens/project/addProjectFlow/add_project_screen.dart';
import 'package:stay_indie/screens/socials/connect_social_page.dart';
import 'package:stay_indie/screens/notification/notification_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stay_indie/models/Profile.dart';
import 'package:stay_indie/screens/offline_screen.dart';
import 'package:stay_indie/screens/profile/epk/epk_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://egawjjsxibcluqdgfyvd.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVnYXdqanN4aWJjbHVxZGdmeXZkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDYyODMyNjIsImV4cCI6MjAyMTg1OTI2Mn0.O1P24fO0gGhLF2-T5XVcl256x_AHiR-eXn-K8Tko2Ng',
  );
  try {
    runApp(const MainApp());
  } catch (e) {
    runApp(OfflineApp());
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      initialRoute: SplashScreen.id, // Set the initial route to LoginScreen
      routes: {
        HomeScreen.id: (context) => HomeScreen(),
        OpportunityScreen.id: (context) => OpportunityScreen(),
        ProfilePage.id: (context) => ProfilePage(
              profileId: currentUserId,
            ),
        AddScreen.id: (context) => AddScreen(),
        ConnectionsScreen.id: (context) => ConnectionsScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        SignUpScreen.id: (context) => SignUpScreen(),
        IndustryScreen.id: (context) => IndustryScreen(),
        InboxScreen.id: (context) => InboxScreen(),
        SearchScreen.id: (context) => SearchScreen(),
        SplashScreen.id: (context) => SplashScreen(),
        LoginPage.id: (context) => LoginPage(),
        RegisterPage.id: (context) => RegisterPage(isRegistering: false),
        SettingPage.id: (context) => SettingPage(),
        ProfileEditPage.id: (context) => ProfileEditPage(),
        AddProjectPage.id: (context) => AddProjectPage(),
        ConnectSocialPage.id: (context) => ConnectSocialPage(),
        NotificationsPage.id: (context) => NotificationsPage(),
        EpkPage.id: (context) => EpkPage(),
      },
    );
  }
}

class OfflineApp extends StatelessWidget {
  const OfflineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      initialRoute: OfflineSplashScreen.id,
    );
  }
}
