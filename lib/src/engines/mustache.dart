import 'dart:io';
import 'package:mustache4dart/mustache4dart.dart' deferred as mustache;
import 'package:dart_express/src/engines/engine.dart';

class MustacheEngine {
  static String ext = '.mustache';

  static handler(
      String filePath, Map<String, dynamic> options, HandlerCallback callback) {
    var locals = options ?? {};

    var file = File.fromUri(Uri.file(filePath));

    file
        .readAsString()
        .then((str) => callback(null, mustache.render(str, locals)))
        .catchError((e) => callback(e, null));
  }

  static Engine use() {
    return Engine(MustacheEngine.ext, MustacheEngine.handler);
  }
}
