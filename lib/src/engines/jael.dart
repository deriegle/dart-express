import 'dart:io';
import 'package:dart_express/src/engines/engine.dart';
import 'package:code_buffer/code_buffer.dart' deferred as jael_code_buffer;
import 'package:jael/jael.dart' deferred as jael;
import 'package:symbol_table/symbol_table.dart' deferred as jael_symbol_table;

class JaelEngine {
  static String ext = '.jl';

  static handler(
      String filePath, Map<String, dynamic> options, HandlerCallback callback) {
    var file = File.fromUri(Uri.file(filePath));

    file.readAsString().then((str) {
      var buffer = jael_code_buffer.CodeBuffer();
      var document = jael.parseDocument(str, sourceUrl: filePath);
      var scope = jael_symbol_table.SymbolTable(values: options);

      jael.Renderer().render(document, buffer, scope);

      callback(null, buffer.toString());
    }).catchError((e) => callback(e, null));
  }

  static Engine use() {
    return Engine(JaelEngine.ext, JaelEngine.handler);
  }
}
