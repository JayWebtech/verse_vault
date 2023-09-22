import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:hive/hive.dart';
import '../../controller/verse_controller.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  late final Box box;
  final VerseController _controller = VerseController();

  @override
  void initState() {
    super.initState();
    Hive.openBox('versevault');
    box = Hive.box('versevault');
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      backgroundColor: const Color(0xFF070707),
      child: Builder(
        // Use Builder to create a new context
        builder: (context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 14, 13, 13),
                      image: const DecorationImage(
                        image: AssetImage(
                            'assets/img/footer.png'), // Replace with your image asset path
                        fit: BoxFit.cover, // You can adjust the fit as needed
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: const EdgeInsets.only(
                        top: 60, left: 15, right: 15, bottom: 15),
                    padding: const EdgeInsets.all(30),
                    width: MediaQuery.of(context).size.width,
                    child: const Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Add a verse",
                            style: TextStyle(
                              fontFamily: 'Millik',
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Verses reminder are displayed randomly",
                            style: TextStyle(
                              fontFamily: 'InfantRegular',
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        top: 10, left: 15, right: 15, bottom: 15),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _controller.chapterController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 25, horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Color(0xFF000000)),
                            ),
                            hintText: 'Enter Chapter & Verse (1 Peter 5:8)',
                          ),
                        ),
                        const SizedBox(height: 25),
                        TextField(
                          controller: _controller.verseTextController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Color(0xFF000000)),
                            ),
                            hintText: 'Enter the verse text',
                          ),
                        ),
                        const SizedBox(height: 25),
                        TextField(
                          controller: _controller.notesController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Color(0xFF000000)),
                            ),
                            hintText: 'Enter additional notes (Optional)',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(15),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Use progressContext to show/hide ProgressHUD
                _controller.submitForm(context,box);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF000000),
                padding: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
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
        ],
      )
      );
        }
      )
    );
  }
}
