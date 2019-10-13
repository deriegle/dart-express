import 'dart:io';
import 'package:mustache4dart/mustache4dart.dart' deferred as mustache;
import 'package:code_buffer/code_buffer.dart' deferred as jael_code_buffer;
import 'package:jael/jael.dart' deferred as jael;
import 'package:symbol_table/symbol_table.dart' deferred as jael_symbol_table;

typedef HandlerCallback = Function(Error e, String rendered);
typedef Handler = Function(
    String filePath, Map<String, dynamic> locals, HandlerCallback cb);

class Engine {
  final String ext;
  final Handler handler;

  const Engine(this.ext, this.handler);

  factory Engine.mustache() {
    return Engine('.mustache', (filePath, options, callback) {
      var locals = options ?? {};

      var file = File.fromUri(Uri.file(filePath));

      file
          .readAsString()
          .then((str) => callback(null, mustache.render(str, locals)))
          .catchError((e) => callback(e, null));
    });
  }

  factory Engine.jael() {
    return Engine('.jl', (filePath, options, callback) {
      // var locals = options ?? {};
      var file = File.fromUri(Uri.file(filePath));

      file
          .readAsString()
          .then((str) {
            var buffer = jael_code_buffer.CodeBuffer();
            var document = jael.parseDocument(str, sourceUrl: filePath);
            var scope = jael_symbol_table.SymbolTable(values: options);

            jael.Renderer().render(document, buffer, scope);

            callback(null, buffer.toString());
          })
          .catchError((e) => callback(e, null));
    });
  }
}
