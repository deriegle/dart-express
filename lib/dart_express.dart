/// Support for doing something awesome.
///
/// More dartdocs go here.
library dart_express;

import 'package:path/path.dart' as path
    show absolute, extension, join, isAbsolute;
import 'dart:convert' as convert;
import 'dart:async';
import 'dart:io';
import 'package:code_buffer/code_buffer.dart';
import 'package:file/local.dart';
import 'package:jael/jael.dart' as jael;
import 'package:jael_preprocessor/jael_preprocessor.dart' as jael;
import 'package:symbol_table/symbol_table.dart';
import 'package:markdown/markdown.dart';
import 'package:mustache4dart/mustache4dart.dart' deferred as mustache;
import 'package:path_to_regexp/path_to_regexp.dart';

export 'dart:io' show HttpStatus;
part 'src/dart_express_base.dart';
part 'src/route.dart';
part 'src/repositories/file_repository.dart';
part 'src/app.dart';
part 'src/view.dart';
part 'src/layer.dart';
part 'src/router.dart';
part 'src/request.dart';
part 'src/response.dart';
part 'src/middleware/body_parser.dart';
part 'src/middleware/init.dart';
part 'src/http_methods.dart';

part 'src/exceptions/view_exception.dart';

part 'src/engines/engine.dart';
part 'src/engines/mustache.dart';
part 'src/engines/html.dart';
part 'src/engines/markdown.dart';
part 'src/engines/jael.dart';

// TODO: Export any libraries intended for clients of this package.
