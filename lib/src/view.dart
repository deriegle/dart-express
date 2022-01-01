part of dart_express;

class _View {
  dynamic rootPath;
  String? defaultEngine;
  late String ext;
  String name;
  late String filePath;
  late Engine engine;

  _View(
    this.name, {
    this.rootPath = '/',
    this.defaultEngine,
    required Map<String, Engine> engines,
  }) {
    final extension = path.extension(name);

    if (extension.isEmpty && defaultEngine == null) {
      throw Error.safeToString('No default engine or extension are provided.');
    }

    var fileName = name;

    if (extension.isEmpty) {
      ext = defaultEngine![0] == '.' ? defaultEngine! : '.$defaultEngine';
      fileName += ext;
    }

    engine = engines[ext] ?? HtmlEngine.use();
    filePath = lookup(fileName);
  }

  void render(
    Map<String, dynamic>? options,
    Function callback,
  ) =>
      engine.handler(
        filePath,
        options,
        callback as dynamic Function(dynamic, String?),
      );

  String lookup(String fileName) {
    String? finalPath;
    final List<String> roots = rootPath is List ? rootPath : [rootPath];

    for (var i = 0; i < roots.length && finalPath == null; i++) {
      final root = roots[i];
      final fullFilePath = path.join(root, fileName);

      final loc = path.isAbsolute(fullFilePath)
          ? fullFilePath
          : path.absolute(fullFilePath);

      finalPath = resolve(loc);
    }

    if (finalPath == null) {
      String dirs;

      if (rootPath is List) {
        dirs = 'directories "${rootPath.join(', ')}" or "${rootPath.last}"';
      } else {
        dirs = 'directory "$rootPath"';
      }

      throw _ViewException(name, ext, dirs);
    }

    return finalPath;
  }

  String? resolve(filePath) {
    if (_exists(filePath) && _isFile(filePath)!) {
      return filePath;
    } else {
      return null;
    }
  }

  bool? _isFile(filePath) {
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
