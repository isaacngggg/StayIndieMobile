import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:stay_indie/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SingleFormPage {
  String titleQuestion;
  String suportingText;
  String storageKey;
  FormInputFieldType inputType;
  late String inputLabel;
  late final TextEditingController controller;
  String? image;
  Icon icon;

  SingleFormPage({
    required this.titleQuestion,
    required this.suportingText,
    required this.storageKey,
    required this.inputType,
    this.image,
    this.icon = const Icon(Icons.abc, color: kPrimaryColour30),
  }) {
    inputLabel = storageKey;
    controller = TextEditingController();
  }

  static List<SingleFormPage> defaultPages = [
    SingleFormPage(
      titleQuestion: 'What is the title of your project?',
      suportingText: 'A catchy title helps in attracting more audience.',
      storageKey: 'title',
      inputType: FormInputFieldType.text,
    ),
    SingleFormPage(
      titleQuestion: 'A short description',
      suportingText: 'A brief intro that focuses on what you have achieved.',
      storageKey: 'description',
      inputType: FormInputFieldType.text,
    ),
    SingleFormPage(
      titleQuestion: 'A catchy summary',
      suportingText: 'A snappy summary that highlights your project.',
      storageKey: 'summary',
      inputType: FormInputFieldType.text,
    ),
    SingleFormPage(
      titleQuestion: 'When did you start?',
      suportingText: 'Do you even remember when it was',
      storageKey: 'start_date',
      inputType: FormInputFieldType.date,
    ),
    SingleFormPage(
      titleQuestion: 'Show me what you\'ve got!',
      suportingText:
          'Add as many images as you want, and yes video and audio too.',
      storageKey: 'media',
      inputType: FormInputFieldType.media,
    ),
  ];

  static List<SingleFormPage> addJourneyPage = [
    SingleFormPage(
      titleQuestion: 'What is the title of your project?',
      suportingText: 'A catchy title helps in attracting more audience.',
      storageKey: 'title',
      inputType: FormInputFieldType.text,
    ),
    SingleFormPage(
      titleQuestion: 'A short description',
      suportingText: 'A brief intro that focuses on what you have achieved.',
      storageKey: 'description',
      inputType: FormInputFieldType.text,
    ),
    SingleFormPage(
      titleQuestion: 'A catchy summary',
      suportingText: 'A snappy summary that highlights your project.',
      storageKey: 'summary',
      inputType: FormInputFieldType.text,
    ),
    SingleFormPage(
      titleQuestion: 'When did you start?',
      suportingText: 'Do you even remember when it was',
      storageKey: 'start_date',
      inputType: FormInputFieldType.date,
    ),
    SingleFormPage(
      titleQuestion: 'Show me what you\'ve got!',
      suportingText:
          'Add as many images as you want, and yes video and audio too.',
      storageKey: 'media',
      inputType: FormInputFieldType.media,
    ),
  ];
}
