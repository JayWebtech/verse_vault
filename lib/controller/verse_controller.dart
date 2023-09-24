import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:hive/hive.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../model/verses_model.dart';
import '../utils/notifications.dart';

class VerseController {
  final TextEditingController chapterController = TextEditingController();
  final TextEditingController verseTextController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  Future<void> submitForm(BuildContext context, Box box) async {
    final String chapter = chapterController.text.trim();
    final String verseText = verseTextController.text.trim();
    final String notes = notesController.text.trim();
    final progress = ProgressHUD.of(context);
    progress?.show();
    if (chapter.isEmpty || verseText.isEmpty) {
      progress?.dismiss();
      OverlayState? state = Overlay.of(context);
      showTopSnackBar(
        state,
        const CustomSnackBar.error(
          message: "Please Chapter and Verse text is required",
        ),
      );
    } else {
      if (box.isEmpty) {
        NotificationService().sendNotificationNextDay();
      }
      final verseData = VerseData()
        ..chapter = chapter
        ..verseText = verseText
        ..notes = notes;

      box.add(verseData);
      progress?.dismiss();
      OverlayState? state = Overlay.of(context);
      showTopSnackBar(
        state,
        const CustomSnackBar.success(
          message: "Successfully added to memory box",
        ),
      );
      // Clear the input fields
      chapterController.clear();
      verseTextController.clear();
      notesController.clear();
    }
  }

  Future<List<VerseData>> getVerses(Box box) async {
    final List<VerseData> verseDataList = [];
    for (var i = 0; i < box.length; i++) {
      final dynamic data = box.getAt(i);
      if (data is VerseData) {
        verseDataList.add(data);
      }
    }
    return verseDataList;
  }

  Future<VerseData?> getRandomVerse(Box box) async {
    final List<VerseData> verseDataList = [];
    for (var i = 0; i < box.length; i++) {
      final dynamic data = box.getAt(i);
      if (data is VerseData) {
        verseDataList.add(data);
      }
    }

    if (verseDataList.isEmpty) {
      return null; // Handle the case where there are no verses in the list
    }

    final Random random = Random();
    final int randomIndex = random.nextInt(verseDataList.length);
    return verseDataList[randomIndex];
  }

  Future<void> deleteVerse(Box box, int index) async {
    await box.deleteAt(index);
  }
}
