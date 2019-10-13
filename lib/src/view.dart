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

  lookup(fileName) {
    String finalPath;
    List<String> roots = []..addAll(this.rootPath);

    for (var i = 0; i < roots.length && finalPath == null; i++) {
      var root = roots[i];

      var loc = path.join(root, name);
      var dir = path.dirname(loc);
      var file = path.basename(loc);

      finalPath = this.resolve(dir, file);
    }

    return finalPath;
  }

  resolve(String dir, String file) {
    var finalPath = path.join(dir, file);
    var stat = this._tryStat(filePath);

    if (stat != null && stat.type == FileSystemEntityType.file) {
      return finalPath;
    }
  }

  render(Map<String, dynamic> options, Function callback) {
    this.engine.handler(this.filePath, options, callback);
  }

  _tryStat(filePath) {
    try {
      return FileStat.statSync(filePath);
    } catch (e) {
      print(e);

      return null;
    }
  }
}
