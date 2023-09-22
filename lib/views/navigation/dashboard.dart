import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../controller/verse_controller.dart';
import '../../model/verses_model.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late final Box box;
  final ValueNotifier<String?> userDataNotifier = ValueNotifier<String?>(null);
  final VerseController verseController = VerseController();
  List<VerseData> verses = [];
  List<bool> showFullVerseList = [];

  @override
  void initState() {
    super.initState();
    Hive.openBox('versevault');
    box = Hive.box('versevault');
    loadVerses();
    loadUserData(box);
  }

  void toggleShowFullVerse(int index) {
    setState(() {
      showFullVerseList[index] = !showFullVerseList[index];
    });
  }

  Future<void> loadUserData(Box box) async {
    var name = box.get('name');
    userDataNotifier.value = name;
  }

  Future<void> loadVerses() async {
    final List<VerseData> loadedVerses = await verseController.getVerses(box);
    setState(() {
      verses = loadedVerses;
      showFullVerseList = List.generate(loadedVerses.length,
          (_) => false); // Initialize showFullVerseList here
    });
  }

  String truncateVerseText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    }
    return "${text.substring(0, maxLength)}...";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 14, 13, 13),
              image: const DecorationImage(
                image: AssetImage('assets/img/footer.png'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            margin:
                const EdgeInsets.only(top: 60, left: 15, right: 15, bottom: 15),
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ValueListenableBuilder<String?>(
                  valueListenable: userDataNotifier,
                  builder: (context, userData, child) {
                    if (userData == null) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF070707),
                        ),
                      );
                    } else if (userData.isEmpty) {
                      return const Text('No data available');
                    } else {
                      return Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Welcome $userData",
                              style: const TextStyle(
                                fontFamily: 'Millik',
                                fontSize: 30,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "What verse do you want to add to your memory box?",
                              style: TextStyle(
                                fontFamily: 'InfantRegular',
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: verses.isEmpty
                ? const Center(
                    child: Text(
                      "No verses available.",
                      style: TextStyle(
                        fontFamily: 'InfantRegular',
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: verses.length,
                    itemBuilder: (context, index) {
                      final verseData = verses[index];
                      final isExpanded = showFullVerseList[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        margin: const EdgeInsets.only(
                            top: 0, left: 15, right: 15, bottom: 10),
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ListTile(
                                title: Text(
                                  verseData.chapter,
                                  style: const TextStyle(
                                    fontFamily: 'InfantBold',
                                    fontSize: 23,
                                    color: Color(0xFF070707),
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      truncateVerseText(verseData.verseText,
                                          isExpanded ? 10000 : 100),
                                      style: const TextStyle(
                                        fontFamily: 'InfantRegular',
                                        fontSize: 18,
                                        color: Color(0xFF070707),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    if (verseData.verseText.length > 100)
                                      GestureDetector(
                                        onTap: () {
                                          toggleShowFullVerse(
                                              index); // Toggle the state for this verse
                                        },
                                        child: Text(
                                          isExpanded
                                              ? "Show less"
                                              : "Show more",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.blue,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
