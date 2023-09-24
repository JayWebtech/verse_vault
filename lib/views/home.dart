import 'package:bible_app/views/navigation/add.dart';
import 'package:bible_app/views/navigation/dashboard.dart';
import 'package:flutter/material.dart';

import 'navigation/view.dart';

void main() {
  runApp(const Home());
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Verse Vault',
      home: Scaffold(
        body: const [
          Dashboard(),
          Add(),
          ViewVerse(),
        ][selectedPageIndex],
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedPageIndex,
          onDestinationSelected: (int index) {
            setState(() {
              selectedPageIndex = index;
            });
          },
          destinations: const <NavigationDestination>[
            NavigationDestination(
              selectedIcon: Icon(Icons.home_filled),
              icon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.add_box_outlined),
              icon: Icon(Icons.add_box_outlined),
              label: 'Add Verse',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.bookmark),
              icon: Icon(Icons.bookmark),
              label: 'Verses',
            ),
          ],
        ),
      ),
    );
  }
}
