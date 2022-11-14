import 'package:flutter/material.dart';

enum GameThemeMode {
  dark,
  light,
}

class GameTheme {
  GameThemeMode mode;
  Color? appbarBackgroundColor;
  Color? appbarTextColor;
  Color? appbarIconColor;

  GameTheme._({
    this.mode = GameThemeMode.dark,
    this.appbarBackgroundColor,

  }){
    this.appbarBackgroundColor = this.appbarBackgroundColor ?? ThemeData.dark().appBarTheme.backgroundColor;

  }

  factory GameTheme.dark() {
    return GameTheme._(
      mode: GameThemeMode.dark,
      appbarBackgroundColor: Colors.black
    );
  }
}