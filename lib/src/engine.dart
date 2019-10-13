import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:mustache4dart/mustache4dart.dart' as mustache;

typedef HandlerCallback = Function(Error e, String rendered);
typedef Handler = Function(String filePath, Map<String, dynamic> locals, HandlerCallback cb);

class Engine {
  final String ext;
  final Handler handler;

  const Engine(this.ext, this.handler);

  factory Engine.mustache() {
    return Engine('.mustache', (filePath, options, callback) {
      var locals = options ?? {};

      var file = File.fromUri(Uri.file(filePath));

      file.readAsString()
        .then((str) => callback(null, mustache.render(str, locals)))
        .catchError((e) => callback(e, null));
    });
  }
}