import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final ExampleGame _game;

  @override
  void initState() {
    super.initState();
    _game = ExampleGame();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: GameWidget(game: _game),
        ),
      ),
    );
  }
}
