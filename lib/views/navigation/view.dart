import 'package:bible_app/controller/verse_controller.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../model/verses_model.dart';

class ViewVerse extends StatefulWidget {
  const ViewVerse({Key? key});

  @override
  State<ViewVerse> createState() => _ViewVerseState();
}

class _ViewVerseState extends State<ViewVerse> {
  final box = Hive.box('versevault');
  final VerseController verseController = VerseController();

  List<VerseData> verses = [];
  List<bool> showFullVerseList = [];
  String searchQuery = ''; // Store the user's search query
  List<VerseData> filteredVerses = []; // Store filtered verses

  @override
  void initState() {
    super.initState();
    loadVerses();
  }

  void toggleShowFullVerse(int index) {
    setState(() {
      showFullVerseList[index] = !showFullVerseList[index];
    });
  }

  Future<void> loadVerses() async {
    final List<VerseData> loadedVerses = await verseController.getVerses(box);
    setState(() {
      verses = loadedVerses;
      showFullVerseList = List.generate(loadedVerses.length, (_) => false);

      // Filter verses based on the search query
      if (searchQuery.isNotEmpty) {
        filteredVerses = verses.where((verse) {
          // You can adjust the filtering logic here as needed
          return verse.chapter
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) ||
              verse.verseText.toLowerCase().contains(searchQuery.toLowerCase());
        }).toList();
      } else {
        filteredVerses = List.from(verses);
      }
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
                image: AssetImage(
                    'assets/img/footer.png'), // Replace with your image asset path
                fit: BoxFit.cover, // You can adjust the fit as needed
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            margin:
                const EdgeInsets.only(top: 60, left: 15, right: 15, bottom: 15),
            padding: const EdgeInsets.all(30),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your verses",
                  style: TextStyle(
                    fontFamily: 'Millik',
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Verses reminder are displayed randomly",
                  style: TextStyle(
                    fontFamily: 'InfantRegular',
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 15),
            child: TextField(
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(10), // Set the border radius
                  borderSide: const BorderSide(
                      color: Colors.grey), // Set the default border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(10), // Set the border radius
                  borderSide: const BorderSide(
                      color: Color(0xFF000000)), // Set the focused border color
                ),
                hintText: 'Search verses',
                prefixIcon: const Icon(Icons.search),
                prefixIconColor: Colors.grey,
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  loadVerses(); // Trigger the verses reload based on search query
                });
              },
            ),
          ),
          Expanded(
            child: filteredVerses.isEmpty
                ? const Center(
                    child: Text(
                      "No matching verses.",
                      style: TextStyle(
                        fontFamily: 'InfantRegular',
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredVerses.length,
                    itemBuilder: (context, index) {
                      final verseData = filteredVerses[index];
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
                                    Text(
                                      verseData.notes.isEmpty
                                          ? "Nil"
                                          : "Notes: ${verseData.notes}",
                                      style: const TextStyle(
                                        fontFamily: 'InfantRegular',
                                        fontSize: 18,
                                        color: Color(0xFF070707),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_rounded,
                                color: Colors.red,
                                size: 30,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Confirm Delete"),
                                      content: const Text(
                                          "Are you sure you want to delete this item?"),
                                      actions: [
                                        TextButton(
                                          child: const Text("Cancel"),
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          },
                                        ),
                                        TextButton(
                                          child: const Text("Delete"),
                                          onPressed: () async {
                                            await verseController.deleteVerse(
                                                box, index);
                                            setState(() {
                                              verses.removeAt(index);
                                            });
                                            // ignore: use_build_context_synchronously
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
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
