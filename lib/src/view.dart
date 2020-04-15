import 'package:dart_express/src/engines/html.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:dart_express/src/engines/engine.dart';

class View {
  dynamic rootPath;
  String defaultEngine;
  String filePath;
  String ext;
  String name;
  Engine engine;

  View(
    this.name, {
    this.rootPath,
    this.defaultEngine,
    Map<String, Engine> engines,
  }) {
    this.ext = path.extension(this.name);

    if (this.ext == null && this.defaultEngine == null) {
      throw Error.safeToString('No default engine or extension are provided.');
    }

    String fileName = name;

    if (this.ext == null || this.ext.isEmpty) {
      this.ext = this.defaultEngine[0] == '.' ? this.defaultEngine : '.${this.defaultEngine}';

      fileName += this.ext;
    }

    this.engine = engines[this.ext] ?? HtmlEngine.use();
    this.filePath = this.lookup(fileName);
  }

  render(Map<String, dynamic> options, Function callback) {
    this.engine.handler(this.filePath, options, callback);
  }

  lookup(String fileName) {
    String finalPath;
    List<String> roots = this.rootPath is List ? this.rootPath : [this.rootPath];

    for (var i = 0; i < roots.length && finalPath == null; i++) {
      var root = roots[i];
      var fullFilePath = path.join(root, fileName);

      var loc = path.isAbsolute(fullFilePath) ? fullFilePath : path.absolute(fullFilePath);

      finalPath = this.resolve(loc);
    }

    return finalPath;
  }

  resolve(filePath) {
    if (this._exists(filePath) && this._isFile(filePath)) {
      return filePath;
    } else {
      return null;
    }
  }

  bool _isFile(filePath) {
    try {
      return File.fromUri(Uri.file(filePath)).statSync().type == FileSystemEntityType.file;
    } catch (e) {
      print('${filePath} is not a file');

      return null;
    }
  }

  bool _exists(filePath) {
    return File.fromUri(Uri.file(filePath)).existsSync();
  }
}
