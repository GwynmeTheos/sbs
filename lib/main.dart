import 'package:flutter/material.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:sbs/package_header.dart';

void main() {
  /* TODO: Fetch user prefs from disk, including prefeered theme and game options. Do this before initializing any other data. */
  GameData gameData = GameData.preloadFromDisk(); // Game's save and event/variable data
  GameTheme themeData = GameTheme.dark(); // Game's UI theme data, includes colors and common widgets

  runApp(
    MaterialApp(
      title: 'Something',
      theme: ThemeData.dark(), // Fallback theme for GameTheme
      home: GameCanvas(
        data: gameData,
        theme: themeData,
      ),
    )
  );
}

class GameCanvas extends StatefulWidget{
  GameCanvas({Key? key, required this.data, required this.theme}) : super(key: key);

  GameData data;
  GameTheme theme;

  @override
  _GameCanvasState createState() => _GameCanvasState();
}

class _GameCanvasState extends State<GameCanvas> {
  
  _GameCanvasState();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Widget>? generateScene(BuildContext ctx) {
    
  }
  
  @override
  Widget build(BuildContext context) {
    MediaQueryData mqd = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hello, world!"),
        actions: [
          IconButton(
            onPressed: () => setState(() {
              widget.theme = GameTheme.dark();
            }),
            icon: const Icon(Icons.refresh)
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          vertical: mqd.size.height * 0.05,
          horizontal: mqd.size.width * 0.05
        ),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: this.generateScene(context) ?? []
        ),
      ),
    );
  }
}