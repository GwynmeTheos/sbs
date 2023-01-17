import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:sbs/package_header.dart';

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

class UIBuilder {
  static Widget drawText(BuildContext context,
    Platform platform,
    String data
  ) {
    return MarkdownBody(
      
      data: data
    );
  }

  static Widget drawChoice(BuildContext context, Platform platform) {
    return Container();
  }
}