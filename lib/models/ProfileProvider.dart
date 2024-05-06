import 'package:flutter/foundation.dart';
import 'package:stay_indie/models/Profile.dart';

class ProfileProvider extends ChangeNotifier {
  Profile profile;

  ProfileProvider({required this.profile});

  void editProfile(Profile newProfile) {
    profile = newProfile;
    notifyListeners();
  }
}
