class Interpreter {
  
  static String parse(String body, Map<String, dynamic> vars) {
    return body.replaceAllMapped(
      RegExp(r"\$\{(\w+)\}", caseSensitive: false),
      (Match m) => vars[m[1]]?.toString() ?? "var_${m[1] ?? "undefined"}"
    );
  }
}