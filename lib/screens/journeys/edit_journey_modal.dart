import 'package:flutter/material.dart';
import 'package:stay_indie/models/Journey.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:stay_indie/widgets/images/UploadButton.dart';
import 'package:stay_indie/utilities/input_fields.dart';
import 'package:intl/intl.dart';
import 'package:stay_indie/constants.dart';
import 'package:stay_indie/widgets/projects/media_carousel.dart';
import 'package:keyboard_emoji_picker/keyboard_emoji_picker.dart';
import 'package:stay_indie/widgets/GRBottomSheet.dart';

class EditJourneyModal extends StatefulWidget {
  const EditJourneyModal({
    super.key,
    required this.journey,
  });

  final Journey journey;

  @override
  State<EditJourneyModal> createState() => _EditJourneyModalState();
}

class _EditJourneyModalState extends State<EditJourneyModal>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;
  late final TextEditingController emojiController;
  late final TextEditingController titleController;
  late final TextEditingController organizationController;
  late final TextEditingController startDateController;
  late final TextEditingController descriptionController;

  List<String> _networkImages = [];
  late String selectedEmoji;
  late Color selectedColor;
  @override
  void initState() {
    selectedEmoji = widget.journey.emoji;
    tabController = TabController(length: 2, vsync: this);
    super.initState();
    _networkImages.addAll(widget.journey.imagesUrls);
    titleController = TextEditingController(text: widget.journey.title);
    organizationController =
        TextEditingController(text: widget.journey.organization);

    startDateController = TextEditingController(
        text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
    descriptionController =
        TextEditingController(text: widget.journey.description);
    emojiController = TextEditingController(text: widget.journey.emoji);
  }

  @override
  void dispose() {
    tabController.dispose();
    titleController.dispose();
    organizationController.dispose();
    startDateController.dispose();
    descriptionController.dispose();
    emojiController.dispose();
    super.dispose();
  }
  // Default emoji

  @override
  Widget build(BuildContext context) {
    Widget avatarWColourPicker = AvatarWColourPicker(
        emoji: emojiController.text,
        setStateFunc: (emoji, color) {
          setState(() {
            selectedEmoji = emoji;
            selectedColor = color;
          });
        });
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20),
          Text('Edit Highlight Details', style: kHeading2),
          Divider(color: kBackgroundColour30),
          TabBar(
            controller: tabController,
            tabs: [
              Tab(
                text: 'Details',
              ),
              Tab(
                text: 'Media',
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.50,
            child: TabBarView(
              controller: tabController,
              children: [
                ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 20),
                  children: [
                    avatarWColourPicker,
                    SizedBox(height: 20),
                    InputFields(children: [
                      TextFormField(
                        controller: titleController,
                        decoration: kPlainTextFieldDecoration.copyWith(
                            labelText: 'Title'),
                      ),
                      kDivider,
                      TextFormField(
                        controller: organizationController,
                        decoration: kPlainTextFieldDecoration.copyWith(
                            labelText: 'Organization'),
                      ),
                      kDivider,
                      TextFormField(
                        controller: startDateController,
                        readOnly: true, // to prevent opening keyboard on tap
                        decoration: kPlainTextFieldDecoration.copyWith(
                          labelText: 'Start Date',
                        ),
                        onTap: () async {
                          final DateTime? date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          startDateController.text =
                              DateFormat('yyyy-MM-dd').format(date!);
                        },
                        validator: (value) =>
                            value == null ? 'Field Required' : null,
                      ),
                      kDivider,
                      TextFormField(
                        controller: descriptionController,
                        decoration: kPlainTextFieldDecoration.copyWith(
                            labelText: 'Description'),
                        maxLines: 4,
                      ),
                    ]),
                    SizedBox(height: 20),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 10),
                    UploadButton(
                      itemId: widget.journey.id,
                      bucket: 'project_medias',
                      updateNetworkImagesFunc: (url) {
                        setState(() {
                          Journey.addImageUrl(url, widget.journey.id);
                          _networkImages.add(url);
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    MediaCarousel(
                      networkImages: _networkImages,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          TextButton(
            onPressed: () {
              widget.journey.emoji = selectedEmoji;
              widget.journey.emojiBgColor = selectedColor;
              widget.journey.title = titleController.text;
              widget.journey.organization = organizationController.text;
              widget.journey.startDate =
                  DateFormat("dd-MM-yyyy").parse(startDateController.text);
              widget.journey.description = descriptionController.text;

              Journey.updateJourney({
                'emoji': selectedEmoji,
                'emoji_bg_color': selectedColor.value,
                'title': titleController.text,
                'organization': organizationController.text,
                'start_date': DateFormat("dd-MM-yyyy")
                    .parse(startDateController.text)
                    .toIso8601String(),
                'description': descriptionController.text,
              }, widget.journey);

              Navigator.pop(context);
            },
            child: Text('Save'),
            style: kPrimaryButtonStyle,
          ),
          SizedBox(height: 10),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
            style: kTextButtonStyle,
          ),
        ],
      ),
    );
  }
}

class AvatarWColourPicker extends StatefulWidget {
  Color selectedColor;
  String emoji;
  Function setStateFunc;

  AvatarWColourPicker(
      {required this.emoji,
      this.selectedColor = const Color(0xFF42A5F5),
      required this.setStateFunc,
      super.key});

  @override
  State<AvatarWColourPicker> createState() => _AvatarWColourPickerState();
}

class _AvatarWColourPickerState extends State<AvatarWColourPicker> {
  late Color _selectedColor = widget.selectedColor;
  String? selectedEmoji;
  bool _hasKeyboard = false;
  @override
  void initState() {
    selectedEmoji = widget.emoji;
    super.initState();
    _checkHasEmojiKeyboard();
  }

  final _pickEmojiResults = <String?>[];
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const KeyboardEmojiPickerWrapper(child: SizedBox.shrink()),
        CircleAvatar(
            backgroundColor: _selectedColor,
            radius: 40.0,
            child: GestureDetector(
              onTap: () async {
                final emoji = await KeyboardEmojiPicker().pickEmoji();
                setState(() {
                  _pickEmojiResults.insert(0, emoji);
                  if (emoji != null) {
                    selectedEmoji = emoji;
                  }
                  widget.setStateFunc(selectedEmoji, _selectedColor);
                });
              },
              child: Container(
                alignment: Alignment.center,
                width: 40,
                child: Expanded(
                  child: Text(
                    selectedEmoji ?? '🚀',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ),
            )),
        formSpacer,
        Expanded(
          child: ColorPicker(
            color: _selectedColor,
            customColorSwatchesAndNames: <ColorSwatch<Object>, String>{
              ColorTools.createPrimarySwatch(const Color(0xFFF8BBD0)):
                  'Pastel Pink',
              ColorTools.createPrimarySwatch(const Color(0xFFE1BEE7)):
                  'Pastel Purple',
              ColorTools.createPrimarySwatch(const Color(0xFFC5CAE9)):
                  'Pastel Blue',
              ColorTools.createPrimarySwatch(const Color(0xFFBBDEFB)):
                  'Pastel Light Blue',
              ColorTools.createPrimarySwatch(const Color(0xFFB2EBF2)):
                  'Pastel Turquoise',
              ColorTools.createPrimarySwatch(const Color(0xFFC8E6C9)):
                  'Pastel Green',
              ColorTools.createPrimarySwatch(const Color(0xFFFFF9C4)):
                  'Pastel Yellow',
              ColorTools.createPrimarySwatch(const Color(0xFFFFCCBC)):
                  'Pastel Orange',
              ColorTools.createPrimarySwatch(kBackgroundColour30):
                  'Black', // Kept black for contrast
              ColorTools.createPrimarySwatch(kPrimaryColour30): 'White',
            },
            onColorChanged: (Color color) {
              setState(() {
                _selectedColor = color;
                widget.setStateFunc(selectedEmoji, _selectedColor);
              });
            },
            pickersEnabled: <ColorPickerType, bool>{
              ColorPickerType.custom: true,
              ColorPickerType.primary: false,
              ColorPickerType.accent: false,
            },
            enableShadesSelection: false,

            // Customize appearance here
            // ... (see examples below)
          ),
        ),
      ],
    );
  }

  void _checkHasEmojiKeyboard() async {
    final hasKeyboard = await KeyboardEmojiPicker().checkHasEmojiKeyboard();
    setState(() {
      _hasKeyboard = hasKeyboard;
    });
  }
}
