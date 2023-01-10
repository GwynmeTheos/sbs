import 'package:flutter/material.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sbs/package_header.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /* TODO: Fetch user prefs from disk, including prefeered theme and game options. Do this before initializing any other data. */
  GameData gameData = GameData.preloadFromDisk(); // Game's save and event/variable data
  GameTheme themeData = GameTheme.dark(); // Game's UI theme data, includes colors and common widgets

  await gameData.loadData();
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
  _GameCanvasState createState() => _GameCanvasState(data: this.data, theme: this.theme);
}

class _GameCanvasState extends State<GameCanvas> {
  
  GameData data;
  GameTheme theme;
  
  _GameCanvasState({required this.data, required this.theme});

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Widget>? generateScene(BuildContext ctx, MediaQueryData mqd) {
    List<Widget> retLis = new List<Widget>.empty(growable: true);
    try {
      List<Widget> textTileLis = buildTextTiles(ctx, mqd);
      List<Widget> choiceTileLis = buildChoiceTiles(ctx, mqd);

      textTileLis.forEach((textTile) {
        retLis.add(textTile);
        retLis.add(SizedBox(height: 10,));
      });
      choiceTileLis.forEach((choiceTile) {
        retLis.add(choiceTile);
        retLis.add(SizedBox(height: 5,));
      });

      return retLis;
    } catch (exx) {
      print(exx);
      return null;
    }
  }

  List<Widget> buildTextTiles(BuildContext ctx, MediaQueryData mqd) {
    List<Widget> retLis = new List<Widget>.empty(growable: true);
    try {
      Markdown(
        data: Interpreter.parse(
          this.data.gameStateScn?.body ?? "Error fetching current scene.",
          this.data.variables
        ),
      );


      return retLis;
    } catch (exx) {
      return retLis;
    }
  }
  List<Widget> buildChoiceTiles(BuildContext ctx, MediaQueryData mqd) {
    List<Widget> retLis = new List<Widget>.empty(growable: true);
    try {
      
      return retLis;
    } catch (exx) {
      return retLis;
    }
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
          children: this.generateScene(context, mqd) ?? []
        ),
      ),
    );
  }
}