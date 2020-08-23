/// Support for doing something awesome.
///
/// More dartdocs go here.
library dart_express;

import 'package:path/path.dart' as path
    show absolute, extension, join, isAbsolute;
import 'dart:convert' as convert;
import 'dart:async';
import 'dart:io';
import 'package:code_buffer/code_buffer.dart' deferred as codebuffer;
import 'package:file/local.dart';
import 'package:jael/jael.dart' as jael;
import 'package:jael_preprocessor/jael_preprocessor.dart'
    deferred as jael_preprocessor;
import 'package:symbol_table/symbol_table.dart';
import 'package:markdown/markdown.dart' deferred as markdown;
import 'package:mustache4dart/mustache4dart.dart' deferred as mustache;
import 'package:path_to_regexp/path_to_regexp.dart';

export 'dart:io' show HttpStatus;

/// Top level classes
part 'src/dart_express_base.dart';
part 'src/route.dart';
part 'src/app.dart';
part 'src/view.dart';
part 'src/layer.dart';
part 'src/router.dart';
part 'src/request.dart';
part 'src/response.dart';
part 'src/http_methods.dart';

/// Repositories
part 'src/repositories/file_repository.dart';

/// Middleware
part 'src/middleware/body_parser.dart';
part 'src/middleware/init.dart';
part 'src/middleware/cors.dart';

/// Exceptions
part 'src/exceptions/view_exception.dart';

/// View Engines
part 'src/engines/engine.dart';
part 'src/engines/mustache.dart';
part 'src/engines/html.dart';
part 'src/engines/markdown.dart';
part 'src/engines/jael.dart';
