import 'package:flutter/foundation.dart';
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

enum PlatformUI {
  desktop,
  web,
  mobile,
  none
}
class UIBuilder {
  static PlatformUI platformFromString(String platform) {
    if (kIsWeb) return PlatformUI.web;
    switch (platform){
      case ('android'):
      case ('ios'):
        return PlatformUI.mobile;
      case ('linux'):
      case ('macos'):
      case ('windows'):
        return PlatformUI.desktop;
      case ('fuchsia'):
      default:
        return PlatformUI.none;
    }
  }

  static Widget drawText(BuildContext context,
    String platform,
    String data
  ) {
    PlatformUI platformUI = platformFromString(platform);

    switch (platformUI){
      case (PlatformUI.desktop):
      case (PlatformUI.web):
      case (PlatformUI.none):
        return MarkdownBody(
          data: data
        );
      case (PlatformUI.mobile):
        return MarkdownBody(
          data: data
        ); 
    }
  }

  static Widget drawChoice(
    BuildContext context,
    String platform
  ) {
    PlatformUI platformUI = platformFromString(platform);

    switch (platformUI){
      case (PlatformUI.desktop):
      case (PlatformUI.web):
      case (PlatformUI.none):
        return Container();
      case (PlatformUI.mobile):
        return Container();
    }
  }
}