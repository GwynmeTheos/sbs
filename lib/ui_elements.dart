import 'package:flutter/material.dart';

enum GameThemeMode {
  dark,
  light,
}

class GameTheme {
  GameThemeMode mode;

  GameTheme._({
    this.mode = GameThemeMode.dark,

  });

  factory GameTheme.dark() {
    return GameTheme._(
      mode: GameThemeMode.dark,
      
    );
  }
}