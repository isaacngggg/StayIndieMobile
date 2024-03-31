import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:stay_indie/objects/Profile.dart';

class EditBasicInfoPage extends StatefulWidget {
  static const String id = 'edit_basic_info_page';

  EditBasicInfoPage({super.key});

  @override
  State<EditBasicInfoPage> createState() => _EditBasicInfoPageState();
}

class _EditBasicInfoPageState extends State<EditBasicInfoPage> {
  Profile userProfile = Profile(
    id: '1',
    username: 'johndoe',
    name: 'John Doe',
    bio: 'Hey, how are you?',
    headline: 'Software Engineer',
    location: 'San Francisco, CA',
    profileImagePath: 'assets/profile_example.jpeg',
    createdAt: DateTime.now(),
  );

  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController headlineController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  @override
  void initState() {
    Profile.getProfileData().then((value) {
      if (value != null) {
        setState(() {
          userProfile = value;
          nameController = TextEditingController(text: userProfile.name);
          bioController = TextEditingController(text: userProfile.bio);
          headlineController =
              TextEditingController(text: userProfile.headline);
          locationController =
              TextEditingController(text: userProfile.location);
        });
      } else {
        print('Profile is null');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Basic Info'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: FormBuilder(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FormBuilderTextField(
                  name: 'name',
                  decoration: InputDecoration(labelText: 'Name'),
                  controller: nameController,
                ),
                FormBuilderTextField(
                  name: 'bio',
                  decoration: InputDecoration(labelText: 'Bio'),
                  controller: bioController,
                  maxLines: 3,
                ),
                FormBuilderTextField(
                  name: 'headline',
                  decoration: InputDecoration(labelText: 'Headline'),
                  controller: headlineController,
                ),
                FormBuilderTextField(
                  name: 'location',
                  decoration: InputDecoration(labelText: 'Location'),
                  controller: locationController,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextButton(
                    style: kSecondaryButtonStyle,
                    onPressed: () {
                      print(locationController.text);
                      userProfile = Profile(
                        id: userProfile.id,
                        username: userProfile.username,
                        name: nameController.text,
                        bio: bioController.text,
                        headline: headlineController.text,
                        location: locationController.text,
                        profileImagePath: userProfile.profileImagePath,
                        createdAt: userProfile.createdAt,
                      );
                      Profile.updateProfile(userProfile);
                      print('done');
                      Navigator.pop(context);
                    },
                    child: Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
