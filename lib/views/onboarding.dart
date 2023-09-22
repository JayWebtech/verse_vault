import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:show_up_animation/show_up_animation.dart';

import '../controller/user_controller.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final UserController _controller = UserController();

  late final Box box;

  @override
  void initState() {
    super.initState();
    box = Hive.box('versevault');
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      backgroundColor: const Color(0xFF070707),
      child: Builder(
        // Use Builder to create a new context
        builder: (progressContext) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(30),
                margin: const EdgeInsets.only(top: 100),
                child: Center(
                  child: Column(
                    children: [
                      Lottie.asset('assets/img/board.json',
                          width: 250, height: 250),
                      ShowUpAnimation(
                        delayStart: const Duration(milliseconds: 500),
                        animationDuration: const Duration(milliseconds: 500),
                        curve: Curves.bounceIn,
                        direction: Direction.vertical,
                        offset: 0.5,
                        child: const Text(
                          "Verse Vault",
                          style: TextStyle(
                              fontFamily: 'Millik',
                              fontSize: 50,
                              color: Color(0xFF070707)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      ShowUpAnimation(
                        delayStart: const Duration(milliseconds: 500),
                        animationDuration: const Duration(milliseconds: 500),
                        curve: Curves.bounceIn,
                        direction: Direction.vertical,
                        offset: 0.5,
                        child: const Text(
                          "Let's get to know you better",
                          style: TextStyle(
                              fontFamily: 'InfantRegular',
                              fontSize: 20,
                              color: Colors.grey),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      ShowUpAnimation(
                        delayStart: const Duration(seconds: 1),
                        animationDuration: const Duration(seconds: 1),
                        curve: Curves.bounceIn,
                        direction: Direction.vertical,
                        offset: 0.5,
                        child: TextFormField(
                          controller: _controller.nameController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 25, horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  10), // Set the border radius
                              borderSide: const BorderSide(
                                  color: Colors
                                      .grey), // Set the default border color
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  10), // Set the border radius
                              borderSide: const BorderSide(
                                  color: Color(
                                      0xFF000000)), // Set the focused border color
                            ),
                            hintText: 'Enter your name',
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      ShowUpAnimation(
                        delayStart: const Duration(seconds: 1),
                        animationDuration: const Duration(seconds: 1),
                        curve: Curves.bounceIn,
                        direction: Direction.vertical,
                        offset: 0.5,
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Use progressContext to show/hide ProgressHUD
                              _controller.submitForm(progressContext, box);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(
                                  0xFF000000), // Set the button color
                              padding: const EdgeInsets.all(
                                  20), // Set the button padding
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10), // Set the border radius
                              ),
                            ),
                            child: const Text(
                              'Proceed',
                              style: TextStyle(
                                fontFamily: 'InfantRegular',
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
