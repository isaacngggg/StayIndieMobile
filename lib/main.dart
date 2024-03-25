import 'package:flutter/material.dart';
import 'package:stay_indie/screens/AddScreen.dart';
import 'package:stay_indie/screens/InboxScreen.dart';
import 'package:stay_indie/screens/ConnectionsScreen.dart';
import 'package:stay_indie/screens/OpportunitiesScreen.dart';
import 'package:stay_indie/screens/HomeScreen.dart';
import 'package:stay_indie/screens/profilescreen.dart';
import 'package:stay_indie/screens/story_screen.dart';
import 'package:stay_indie/screens/LoginScreen.dart';
import 'package:stay_indie/screens/SignUpScreen.dart';
import 'package:stay_indie/screens/welcome/IndustryScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:stay_indie/screens/ChatScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://egawjjsxibcluqdgfyvd.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVnYXdqanN4aWJjbHVxZGdmeXZkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDYyODMyNjIsImV4cCI6MjAyMTg1OTI2Mn0.O1P24fO0gGhLF2-T5XVcl256x_AHiR-eXn-K8Tko2Ng',
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      initialRoute: InboxScreen.id, // Set the initial route to LoginScreen
      routes: {
        HomeScreen.id: (context) => HomeScreen(),
        ProfileScreen.id: (context) => ProfileScreen(),
        OpportunityScreen.id: (context) => OpportunityScreen(),
        AddScreen.id: (context) => AddScreen(),
        ConnectionsScreen.id: (context) => ConnectionsScreen(),
        StoryScreen.id: (context) => StoryScreen(
              meta: 'Client',
              title: 'Office Education Krzysztof',
              body:
                  'Wix provides a great solution for business owners who want to create their own white-label apps. One of the main requests of these users is to have more customization abilities, in order to achieve more personalized and unique looking apps that match their brand.',
              images: ['', ''],
            ),
        LoginScreen.id: (context) => LoginScreen(),
        SignUpScreen.id: (context) => SignUpScreen(),
        IndustryScreen.id: (context) => IndustryScreen(),
        ChatScreen.id: (context) => ChatScreen(),
        InboxScreen.id: (context) => InboxScreen(),
      },
    );
  }
}
