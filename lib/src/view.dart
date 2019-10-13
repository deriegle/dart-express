import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:dart_express/src/engine.dart';

class ViewEngine {
  final String _value;
  const ViewEngine._internal(this._value);
  toString() => _value;

  static const MUSTACHE = ViewEngine._internal('mustache');
}

class ViewOptions {
  ViewEngine defaultViewEngine;
  List<Engine> engines;
  String rootPath;

  ViewOptions(
      {this.defaultViewEngine = ViewEngine.MUSTACHE,
      this.engines = const [],
      this.rootPath = 'views'});
}

class View {
  dynamic rootPath;
  ViewEngine defaultEngine;
  String filePath;
  String ext;
  String name;
  Engine engine;

  View(this.name,
      {this.rootPath, this.defaultEngine, Map<String, dynamic> engines}) {
    this.ext = path.extension(this.name);

    if (this.ext == null && this.defaultEngine == null) {
      throw Error.safeToString('No default engine or extension are provided.');
    }

    String fileName = name;

    if (this.ext == null || this.ext.isEmpty) {
      this.ext = this.defaultEngine._value[0] == '.'
          ? this.defaultEngine._value
          : '.${this.defaultEngine._value}';

      fileName += this.ext;
    }

    if (engines[this.ext] == null) {
      if (this.ext == '.mustache') {
        engines[this.ext] = Engine.mustache();
      }
    }

    this.engine = engines[this.ext];
    this.filePath = this.lookup(fileName);
  }

  render(Map<String, dynamic> options, Function callback) {
    this.engine.handler(this.filePath, options, callback);
  }

  lookup(String fileName) {
    String finalPath;
    List<String> roots = this.rootPath is List ? this.rootPath : [this.rootPath];

    print({
      'fileName': fileName,
      'roots': roots,
    });

    for (var i = 0; i < roots.length && finalPath == null; i++) {
      var root = roots[i];
      var loc = path.join(root, fileName);

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
    return File.fromUri(Uri.file(filePath)).statSync().type == FileSystemEntityType.file;
  }

  bool _exists(filePath) {
    return File.fromUri(Uri.file(filePath)).existsSync();
  }
}
