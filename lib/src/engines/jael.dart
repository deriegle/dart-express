part of dart_express;

class JaelEngine {
  static String ext = '.jael';

  static Future<void> handler(
    String filePath,
    Map<String, dynamic> options,
    HandlerCallback callback, [
    FileRepository fileRepository = const RealFileRepository(),
  ]) async {
    await jael_preprocessor.loadLibrary();
    await codebuffer.loadLibrary();

    try {
      var fs = LocalFileSystem();

      final str = await fileRepository.readAsString(Uri.file(filePath));
      // Store any parsing/resolution/rendering errors
      var errors = <jael.JaelError>[];

      // Parse the document, of course.
      var buffer = codebuffer.CodeBuffer();
      var document =
          jael.parseDocument(str, sourceUrl: filePath, onError: errors.add);

      // Resolve template includes, etc.
      document = await jael_preprocessor.resolve(
        document,
        fs.directory('views'),
        onError: errors.add,
      );

      // Render an error page if anything went wrong.
      if (errors.isNotEmpty) {
        jael.Renderer.errorDocument(errors, buffer);
        return callback(null, buffer.toString());
      }

      // Everything went okay - now render.
      // In case the rendering throws an error, be prepared to catch and
      // render it.
      try {
        final scope = SymbolTable(values: options);
        jael.Renderer()
            .render(document, buffer, scope, strictResolution: false);
      } on jael.JaelError catch (e) {
        jael.Renderer.errorDocument([e], buffer..clear());
        return callback(null, buffer.toString());
      }
      return callback(null, buffer.toString());
    } catch (e) {
      callback(e, null);
      return null;
    }
  }

  /// Call this method to add the JaelEngine to your app
  ///
  /// app.engine(JaelEngine.use());
  ///
  /// Set the view engine to "jael" to not require the .jael extension when rendering Jael files.
  ///
  /// app.set('view engine', 'jael');
  static Engine use() => Engine(JaelEngine.ext, JaelEngine.handler);
}
