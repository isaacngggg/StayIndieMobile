import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stay_indie/constants.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:stay_indie/models/Profile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stay_indie/utilities/input_fields.dart';

class ProfileEditPage extends StatefulWidget {
  static const String id = '/myprofile/edit';

  ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController headlineController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController ytShortUrlController = TextEditingController();

  @override
  void initState() {
    nameController = TextEditingController(text: currentUserProfile.name);
    bioController = TextEditingController(text: currentUserProfile.bio);
    headlineController =
        TextEditingController(text: currentUserProfile.headline);
    locationController =
        TextEditingController(text: currentUserProfile.location);
    ytShortUrlController =
        TextEditingController(text: currentUserProfile.ytShortUrl);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: FormBuilder(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AvaterImageEditor(
                    bucket: 'profile_images', setStateFunc: (url) {}),
                formSpacer,
                InputFields(children: [
                  FormBuilderTextField(
                    name: 'name',
                    decoration:
                        kPlainTextFieldDecoration.copyWith(labelText: 'Name'),
                    controller: nameController,
                  ),
                  kDivider,
                  FormBuilderTextField(
                    name: 'bio',
                    decoration:
                        kPlainTextFieldDecoration.copyWith(labelText: 'Bio'),
                    controller: bioController,
                    maxLines: 3,
                  ),
                  kDivider,
                  FormBuilderTextField(
                    name: 'headline',
                    decoration: kPlainTextFieldDecoration.copyWith(
                        labelText: 'Headline'),
                    controller: headlineController,
                  ),
                  kDivider,
                  FormBuilderTextField(
                    name: 'location',
                    decoration: kPlainTextFieldDecoration.copyWith(
                        labelText: 'Location'),
                    controller: locationController,
                  ),
                ]),
                formSpacer,
                InputFields(
                  children: [
                    FormBuilderTextField(
                      name: 'yt_short_url',
                      decoration: kPlainTextFieldDecoration.copyWith(
                          labelText: 'Upload Youtube Shorts'),
                      controller: ytShortUrlController,
                    ),
                  ],
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextButton(
                    style: kPrimaryButtonStyle,
                    onPressed: () {
                      print(locationController.text);

                      Map<String, dynamic> userProfile = {
                        'id': currentUserId,
                        'name': nameController.text,
                        'bio': bioController.text,
                        'headline': headlineController.text,
                        'location': locationController.text,
                        'yt_short_url': ytShortUrlController.text,
                      };
                      Profile.updateProfile(currentUserId, userProfile);
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

class AvaterImageEditor extends StatefulWidget {
  final String bucket;
  final Function setStateFunc;
  const AvaterImageEditor({
    required this.bucket,
    required this.setStateFunc,
    super.key,
  });

  @override
  State<AvaterImageEditor> createState() => _AvaterImageEditorState();
}

class _AvaterImageEditorState extends State<AvaterImageEditor> {
  late String profileImageUrl;
  @override
  void initState() {
    profileImageUrl = currentUserProfile.profileImageUrl;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
              bottom: 0,
              child: Icon(
                Icons.camera_alt,
                size: 30,
                color: kBackgroundColour10,
              )),
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(profileImageUrl),
          ),
        ],
      ),
      onTap: () async {
        final ImagePicker picker = ImagePicker();
        final XFile? image =
            await picker.pickImage(source: ImageSource.gallery);
        if (image == null) return;
        final imageBytes = await image.readAsBytes();

        final imagePath = '$currentUserId/profile.png';

        await supabase.storage
            .from(widget.bucket)
            .remove([imagePath]).whenComplete(() => print('removed'));

        await supabase.storage
            .from(widget.bucket)
            .uploadBinary(imagePath, imageBytes)
            .whenComplete(() async {
          final url = await supabase.storage
              .from(widget.bucket)
              .getPublicUrl(imagePath);
          currentUserProfile.profileImageUrl = url;
          widget.setStateFunc(url);
        });
      },
    );
  }
}
