import 'dart:core';
import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:bible_app/controller/verse_controller.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import '../model/verses_model.dart';

class NotificationService {
   void sendNotificationMorning() async {
    DateTime dateTime = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 7, 30);

    await Hive.initFlutter();
    final Box verseBox = await Hive.openBox('versevault');
    final verseController = VerseController();
    final VerseData? randomVerse =
        await verseController.getRandomVerse(verseBox);

    if (randomVerse != null) {
      final alarmSettings = AlarmSettings(
        id: 42,
        dateTime: dateTime,
        assetAudioPath: 'assets/audio/alarm.mp3',
        loopAudio: false,
        vibrate: false,
        volumeMax: false,
        fadeDuration: 3.0,
        notificationTitle: randomVerse.chapter,
        notificationBody: randomVerse.verseText,
        enableNotificationOnKill: true,
      
      );
      await Alarm.set(alarmSettings: alarmSettings);
    }
    return Future.value();
  }

  void sendNotificationNextDay() async {
    DateTime dateTime = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 7, 30);

    await Hive.initFlutter();
    final Box verseBox = await Hive.openBox('versevault');
    final verseController = VerseController();
    final VerseData? randomVerse =
        await verseController.getRandomVerse(verseBox);

    if (randomVerse != null) {
      final alarmSettings = AlarmSettings(
        id: 43,
        dateTime: dateTime.add(const Duration(days: 1)),
        assetAudioPath: 'assets/audio/alarm.mp3',
        loopAudio: false,
        vibrate: false,
        volumeMax: false,
        fadeDuration: 3.0,
        notificationTitle: randomVerse.chapter,
        notificationBody: randomVerse.verseText,
        enableNotificationOnKill: true,
      );
      await Alarm.set(alarmSettings: alarmSettings);
    }
  }
}
