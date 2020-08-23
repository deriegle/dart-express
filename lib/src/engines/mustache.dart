part of dart_express;

class MustacheEngine {
  static String ext = '.mustache';

  static Future<void> handler(
    String filePath,
    Map<String, dynamic> options,
    HandlerCallback callback, [
    FileRepository fileRepository = const _RealFileRepository(),
  ]) async {
    await mustache.loadLibrary();

    try {
      final fileContents =
          await fileRepository.readAsString(Uri.file(filePath));
      final rendered = mustache.render(fileContents, options ?? {});

      return callback(null, rendered);
    } catch (e) {
      callback(e, null);
      return null;
    }
  }

  static Engine use() => Engine(MustacheEngine.ext, MustacheEngine.handler);
}
