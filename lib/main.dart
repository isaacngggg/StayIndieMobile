import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stay_indie/constants.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:youtube_shorts/youtube_shorts.dart';
import 'firebase_options.dart';

import 'package:go_router/go_router.dart';
import 'package:stay_indie/router.dart';

import 'package:stay_indie/screens/welcome/IndustryScreen.dart';
import 'package:stay_indie/screens/loginSignUpFlow/login_page.dart';
import 'package:stay_indie/screens/loginSignUpFlow/signup_page.dart';
import 'package:stay_indie/screens/settings/settings_page.dart';
import 'package:stay_indie/screens/project/addProjectFlow/add_project_screen.dart';
import 'package:stay_indie/screens/socials/connect_social_page.dart';
import 'package:stay_indie/screens/notification/notification_page.dart';
import 'package:stay_indie/screens/offline_screen.dart';
import 'package:stay_indie/screens/profile/epk/epk_page.dart';
import 'package:stay_indie/screens/project/project_page.dart';
import 'package:stay_indie/screens/contacts_page.dart';
import 'package:stay_indie/screens/loginSignUpFlow/SplashScreen.dart';
import 'package:stay_indie/screens/data_deletion_page.dart';
import 'package:stay_indie/screens/journeys/add_journey_screen.dart';
import 'package:stay_indie/screens/chat/InboxScreen.dart';
import 'package:stay_indie/test_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://egawjjsxibcluqdgfyvd.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVnYXdqanN4aWJjbHVxZGdmeXZkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDYyODMyNjIsImV4cCI6MjAyMTg1OTI2Mn0.O1P24fO0gGhLF2-T5XVcl256x_AHiR-eXn-K8Tko2Ng',
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  MediaKit.ensureInitialized();
  runApp(const ProviderScope(child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: theme,
      routerConfig: router,

      // initialRoute: SplashScreen.id, // Set the initial route to LoginScreen
      // routes: {
      //   IndustryScreen.id: (context) => IndustryScreen(),
      //   InboxScreen.id: (context) => InboxScreen(),
      //   SplashScreen.id: (context) => SplashScreen(),
      //   LoginPage.id: (context) => LoginPage(),
      //   RegisterPage.id: (context) => RegisterPage(isRegistering: false),
      //   SettingPage.id: (context) => SettingPage(),
      //   AddProjectPage.id: (context) => AddProjectPage(),
      //   ConnectSocialPage.id: (context) => ConnectSocialPage(),
      //   NotificationsPage.id: (context) => NotificationsPage(),
      //   EpkPage.id: (context) => EpkPage(),
      //   ProjectsPage.id: (context) => ProjectsPage(),
      //   DataDeletionPage.id: (context) => DataDeletionPage(),
      //   TestPage.id: (context) => TestPage(),
    );
  }
}

class OfflineApp extends StatelessWidget {
  const OfflineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      initialRoute: OfflineSplashScreen.id,
    );
  }
}
