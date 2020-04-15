import 'package:dart_express/src/repositories/file_repository.dart';
import 'package:mustache4dart/mustache4dart.dart' deferred as mustache;
import 'package:dart_express/src/engines/engine.dart';

class MustacheEngine {
  static String ext = '.mustache';

  static handler(
    String filePath,
    Map<String, dynamic> options,
    HandlerCallback callback, [
    FileRepository fileRepository = const RealFileRepository(),
  ]) async {
    try {
      var fileContents = await fileRepository.readAsString(Uri.file(filePath));
      var rendered = mustache.render(fileContents, options ?? {});

      callback(null, rendered);
      return rendered;
    } catch (e) {
      callback(e, null);
      return null;
    }
  }

  static Engine use() {
    return Engine(MustacheEngine.ext, MustacheEngine.handler);
  }
}
