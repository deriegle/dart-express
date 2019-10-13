import 'dart:io';
import 'package:dart_express/src/engines/engine.dart';

class HtmlEngine {
  static String ext = '.html';

  static handler(
      String filePath, Map<String, dynamic> locals, HandlerCallback callback) {
    var file = File.fromUri(Uri.file(filePath));

    file
        .readAsString()
        .then((str) => callback(null, str))
        .catchError((e) => callback(e, null));
  }

  static Engine use() {
    return Engine(HtmlEngine.ext, HtmlEngine.handler);
  }
}
