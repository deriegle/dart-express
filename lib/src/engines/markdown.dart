import 'package:dart_express/dart_express.dart';
import 'package:dart_express/src/repositories/file_repository.dart';
import 'package:markdown/markdown.dart';

class MarkdownEngine {
  static String ext = '.md';

  /// Called when rendering Markdown files in a Response
  ///
  /// Renders Markdown file into HTML. Use [locals] to configure the rendered HTML.
  ///
  /// locals['title'] will set the title.
  ///
  /// locals['head'] will be rendered after the <title/> element
  ///
  /// locals['beforeMarkdown'] will be rendered at the top of the body before the markdown.
  ///
  /// locals['afterMarkdown'] will be rendered at the bottom of the body after the markdown
  static Future<String> handler(
    String filePath,
    Map<String, dynamic> locals,
    HandlerCallback callback, [
    FileRepository fileRepository = const RealFileRepository(),
  ]) async {
    try {
      final String fileContents = await fileRepository.readAsString(Uri.file(filePath));
      final String rendered = _wrapInHTMLTags(markdownToHtml(fileContents), locals);
      callback(null, rendered);
      return rendered;
    } catch (e) {
      callback(e, null);
      return null;
    }
  }

  static _wrapInHTMLTags(String html, Map<String, dynamic> options) {
    return '''
    <html>
    <head>
      <title>${options['title'] ?? ''}</title>
      ${options['head']}
    </head>
    <body>
      ${options['beforeMarkdown']}
      ${html}
      ${options['afterMarkdown']}
    </body>
    </html>
    ''';
  }

  /// Call this method to add the MarkdownEngine to your app
  ///
  /// app.engine(MarkdownEngine.use());
  ///
  /// If you're going to use markdown as your default, you can set your default view engine using app.set('views engine', 'md').
  /// This will allow you to not use the ".md" extension when rendering your markdown files.
  static Engine use() {
    return Engine(MarkdownEngine.ext, MarkdownEngine.handler);
  }
}
