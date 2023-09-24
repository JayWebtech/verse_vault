import 'package:alarm/alarm.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:bible_app/model/verses_model.dart';
import 'package:bible_app/utils/notifications.dart';
import 'package:bible_app/views/home.dart';
import 'package:bible_app/views/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

int? isviewed;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isviewed = prefs.getInt('onBoard');

  await Hive.initFlutter();
  Hive.registerAdapter(VerseDataAdapter());
  await Hive.openBox('versevault');

  await Alarm.init();

  NotificationService().sendNotificationMorning();

  bool hasExecuted = false;

  Alarm.ringStream.stream.listen((_) {
    if (!hasExecuted) {
      NotificationService().sendNotificationNextDayMorning();
      NotificationService().sendNotificationEvening();
      hasExecuted = true;
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Ubuntu'),
      home: const SplashScreenPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      backgroundColor: const Color(0xFF070707),
      duration: 3000,
      splashIconSize: 100,
      splash: const Column(
        children: [
          Text(
            "Verse Vault",
            style: TextStyle(
                fontFamily: 'Millik', fontSize: 40, color: Colors.white),
          ),
          Text(
            "Making God's Word Unforgettable",
            style: TextStyle(
                fontFamily: 'InfantRegular', fontSize: 20, color: Colors.white),
          ),
        ],
      ),
      nextScreen: const HomeScreen(),
      splashTransition: SplashTransition.scaleTransition,
      pageTransitionType: PageTransitionType.leftToRight,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Verse Vault',
      debugShowCheckedModeBanner: false,
      home: isviewed != 0 ? const Onboarding() : const Home(),
    );
  }
}
