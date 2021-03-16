part of dart_express;

class _View {
  dynamic rootPath;
  String defaultEngine;
  String filePath;
  String ext;
  String name;
  Engine engine;

  _View(
    this.name, {
    this.rootPath = '/',
    this.defaultEngine,
    Map<String, Engine> engines,
  }) {
    ext = path.extension(name);

    if (ext == null && defaultEngine == null) {
      throw Error.safeToString('No default engine or extension are provided.');
    }

    var fileName = name;

    if (ext == null || ext.isEmpty) {
      ext = defaultEngine[0] == '.' ? defaultEngine : '.$defaultEngine';

      fileName += ext;
    }

    engine = engines[ext] ?? HtmlEngine.use();
    filePath = lookup(fileName);
  }

  void render(Map<String, dynamic> options, Function callback) =>
      engine.handler(filePath, options, callback);

  String lookup(String fileName) {
    String finalPath;
    final List<String> roots = rootPath is List ? rootPath : [rootPath];

    for (var i = 0; i < roots.length && finalPath == null; i++) {
      final root = roots[i];
      final fullFilePath = path.join(root, fileName);

      final loc = path.isAbsolute(fullFilePath)
          ? fullFilePath
          : path.absolute(fullFilePath);

      finalPath = resolve(loc);
    }

    return finalPath;
  }

  String resolve(filePath) {
    if (_exists(filePath) && _isFile(filePath)) {
      return filePath;
    } else {
      return null;
    }
  }

  bool _isFile(filePath) {
    try {
      return File.fromUri(Uri.file(filePath)).statSync().type ==
          FileSystemEntityType.file;
    } catch (e) {
      print('$filePath is not a file');

      return null;
    }
  }

  bool _exists(filePath) {
    return File.fromUri(Uri.file(filePath)).existsSync();
  }
}
