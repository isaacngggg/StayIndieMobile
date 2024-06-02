import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/mybusinessbusinessinformation/v1.dart';
import 'package:stay_indie/constants.dart';
import 'package:stay_indie/models/Profile.dart';
import 'package:stay_indie/screens/archive/ConnectionsScreen.dart';
import 'package:stay_indie/screens/chat/chat_page.dart';
import 'package:stay_indie/screens/profile/profile_edit_page.dart';

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
import 'package:stay_indie/screens/chat/inbox_page.dart';
import 'package:stay_indie/screens/profile/profile_page.dart';
import 'package:stay_indie/test_page.dart';
import 'package:stay_indie/screens/home.dart';

import 'package:stay_indie/screens/qr_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorAKey = GlobalKey<NavigatorState>(debugLabel: 'shellA');
final _shellNavigatorBKey = GlobalKey<NavigatorState>(debugLabel: 'shellB');
final _shellNavigatorCKey = GlobalKey<NavigatorState>(debugLabel: 'shellC');

final GoRouter router = GoRouter(
  initialLocation: SplashScreen.id,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // the UI shell
        return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
      },
      branches: [
        // first branch (A)
        StatefulShellBranch(
          navigatorKey: _shellNavigatorAKey,
          routes: [
            // top route inside branch
            GoRoute(
              path: '/inbox',
              pageBuilder: (context, state) => NoTransitionPage(
                child: InboxPage(),
              ),
            ),
          ],
        ),
        // second branch (B)
        StatefulShellBranch(
          navigatorKey: _shellNavigatorBKey,
          routes: [
            // top route inside branch
            GoRoute(
              path: '/contacts',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ContactsPage(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorCKey,
          routes: [
            // top route inside branch
            GoRoute(
              path: '/myprofile',
              pageBuilder: (context, state) => NoTransitionPage(
                child: ProfilePage(
                  profileId: currentUserId,
                  isProfilePage: true,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: SplashScreen.id,
      pageBuilder: (context, state) => NoTransitionPage(
        child: SplashScreen(),
      ),
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: ProfilePage.id + '/:id',
      builder: (context, state) =>
          ProfilePage(profileId: state.pathParameters['id'] ?? currentUserId),
      routes: [
        GoRoute(
          redirect: redirect,
          path: ProjectsPage.id,
          pageBuilder: (context, state) => NoTransitionPage(
            child: SplashScreen(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: LoginPage.id,
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: RegisterPage.id,
      builder: (context, state) => RegisterPage(isRegistering: false),
    ),
    GoRoute(
      redirect: redirect,
      path: SettingPage.id,
      builder: (context, state) => SettingPage(),
    ),
    GoRoute(
      redirect: redirect,
      path: ProfileEditPage.id,
      builder: (context, state) => ProfileEditPage(),
    ),
    GoRoute(
      redirect: redirect,
      path: AddProjectPage.id,
      builder: (context, state) => AddProjectPage(),
    ),
    GoRoute(
      redirect: redirect,
      path: ConnectSocialPage.id,
      builder: (context, state) => ConnectSocialPage(),
    ),
    GoRoute(
      redirect: redirect,
      path: TestPage.id,
      builder: (context, state) => TestPage(),
    ),
    GoRoute(
      redirect: redirect,
      path: DataDeletionPage.id,
      builder: (context, state) => const DataDeletionPage(),
    ),
    GoRoute(
      redirect: redirect,
      path: QrPage.id,
      builder: (context, state) => const QrPage(),
    ),
    GoRoute(
      redirect: redirect,
      path: ChatPage.id + '/:id',
      name: ChatPage.id,
      builder: (context, state) {
        return ChatPage(
          chatId: state.pathParameters['id'] ?? '',
        );
      },
    ),
    GoRoute(
      redirect: redirect,
      path: AddJourneyPage.id,
      // builder: (context, state)
    ),
  ],
);

String? redirect(BuildContext context, GoRouterState state) {
  final isAuthenticated =
      supabase.auth.currentUser; // your logic to check if user is authenticated
  if (isAuthenticated == null) {
    return '/login';
  } else {
    return null; // return "null" to display the intended route without redirecting
  }
}
