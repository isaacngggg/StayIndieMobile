import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stay_indie/constants.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:stay_indie/models/Profile.dart';
import 'package:image_picker/image_picker.dart';

class EditBasicInfoPage extends StatefulWidget {
  static const String id = 'edit_basic_info_page';

  EditBasicInfoPage({super.key});

  @override
  State<EditBasicInfoPage> createState() => _EditBasicInfoPageState();
}

class _EditBasicInfoPageState extends State<EditBasicInfoPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController headlineController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  @override
  void initState() {
    nameController = TextEditingController(text: currentUserProfile.name);
    bioController = TextEditingController(text: currentUserProfile.bio);
    headlineController =
        TextEditingController(text: currentUserProfile.headline);
    locationController =
        TextEditingController(text: currentUserProfile.location);

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
                AvaterImageEditor(
                    bucket: 'profile_images',
                    setStateFunc: (url) {
                      setState(() {
                        currentUserProfile.profileImageUrl = url;
                      });
                    }),
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

class AvaterImageEditor extends StatelessWidget {
  final String bucket;
  final Function setStateFunc;
  const AvaterImageEditor({
    required this.bucket,
    required this.setStateFunc,
    super.key,
  });

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
            backgroundImage: NetworkImage(currentUserProfile.profileImageUrl),
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
            .from(bucket)
            .remove([imagePath]).whenComplete(() => print('removed'));

        await supabase.storage
            .from(bucket)
            .uploadBinary(imagePath, imageBytes)
            .whenComplete(() async {
          final url =
              await supabase.storage.from(bucket).getPublicUrl(imagePath);

          setStateFunc(url);
        });
      },
    );
  }
}
