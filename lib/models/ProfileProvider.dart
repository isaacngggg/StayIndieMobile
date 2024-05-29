import 'package:flutter/foundation.dart';
import 'package:stay_indie/models/Profile.dart';

class CurrentProfileProvider extends ChangeNotifier {
  Profile profile;

  CurrentProfileProvider({required this.profile});

  void editProfile(Profile newProfile) {
    profile = newProfile;
    notifyListeners();
  }
}
