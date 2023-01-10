import 'package:sbs/package_header.dart';

class Interpreter {
  static String parse(String body, Map<String, Variable?> vars) {
    return body.replaceAllMapped(
      RegExp(r"\$\{(\w+)\}", caseSensitive: false),
      (Match m) => vars[m[1]]?.currentDescriptor ?? "var_${m[1] ?? "undefined"}"
    );
  }
}

class Utils {
  static double distanceFromDouble(double x, double y) => x<y?y-x:x-y;
  static int distanceFromInt(int x, int y) => distanceFromDouble(x.toDouble(), y.toDouble()).toInt();
}