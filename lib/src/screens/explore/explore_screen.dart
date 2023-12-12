import 'package:flutter/material.dart';
import 'package:interstellar/src/screens/explore/magazines_screen.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Explore'),
          bottom: const TabBar(tabs: [
            Tab(
              text: 'Magazines',
              icon: Icon(Icons.article),
            ),
            Tab(
              text: 'Collections',
              icon: Icon(Icons.newspaper),
            ),
            Tab(
              text: 'People',
              icon: Icon(Icons.account_circle),
            ),
          ]),
        ),
        body: const TabBarView(
            children: [MagazinesScreen(), Placeholder(), Placeholder()]),
      ),
    );
  }
}