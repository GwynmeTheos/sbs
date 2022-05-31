import 'package:flutter/material.dart';
import 'package:sbs/package_header.dart';

void main() {
  GameData gameData = GameData.preloadFromDisk();
  GameTheme themeData = GameTheme.dark();

  runApp(
    MaterialApp(
      title: 'Something',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GameCanvas(
        data: gameData,
        theme: themeData,
      ),
    )
  );
}

class GameCanvas extends StatefulWidget{
  const GameCanvas({Key? key, required this.data, required this.theme}) : super(key: key);

  final GameData data;
  final GameTheme theme;

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

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello, world!"),
      ),
      body: Text("Goodbye, world"),
    );
  }
}