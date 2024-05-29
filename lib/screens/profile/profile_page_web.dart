import 'dart:async';

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui';

import 'package:stay_indie/constants.dart';
import 'package:stay_indie/models/ChatInfo.dart';
import 'package:stay_indie/models/ProfileProvider.dart';

import 'package:stay_indie/screens/chat/ChatScreen.dart';

import 'package:stay_indie/screens/profile/profile_edit_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stay_indie/models/Profile.dart';
import 'package:stay_indie/utilities/LinePainter.dart';
import 'package:stay_indie/widgets/social/SocialMetricList.dart';
import 'package:stay_indie/models/connections/Spotify/Track.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:stay_indie/widgets/profile/CoverButton.dart';
import 'package:stay_indie/screens/profile/pages_button.dart';
import 'package:stay_indie/widgets/journeys/my_journey_widget.dart';

// import for topbar
import 'package:stay_indie/screens/settings/settings_page.dart';
import 'package:stay_indie/widgets/avatars/CircleAvatarWBorder.dart';
import 'package:stay_indie/widgets/navigation/new_nav_bar.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
