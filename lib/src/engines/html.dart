part of dart_express;

class HtmlEngine {
  static String ext = '.html';

  /// Called when rendering an HTML file in the Response
  ///
  /// [locals] is ignored for HTML files
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

  /// Call this method to add the HtmlEngine to your app (This is added by default)
  ///
  /// app.engine(HtmlEngine.use());
  static Engine use() => Engine(HtmlEngine.ext, HtmlEngine.handler);
}
