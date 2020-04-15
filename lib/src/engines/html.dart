import 'package:dart_express/src/engines/engine.dart';
import 'package:dart_express/src/repositories/file_repository.dart';

class HtmlEngine {
  static String ext = '.html';

  static Future<String> handler(
    String filePath,
    Map<String, dynamic> locals,
    HandlerCallback callback, [
    FileRepository fileRepository = const RealFileRepository(),
  ]) async {
    try {
      var uri = Uri.file(filePath);
      final rendered = await fileRepository.readAsString(uri);
      callback(null, rendered);
      return rendered;
    } catch (e) {
      callback(e, null);
      return null;
    }
  }

  static Engine use() {
    return Engine(HtmlEngine.ext, HtmlEngine.handler);
  }
}
