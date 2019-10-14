import 'package:dart_express/src/request.dart';
import 'package:dart_express/src/response.dart';

class Middleware {
  static final String name = 'EXPRESS_INIT';

  static init(Request req, Response res, Function next) {
    next();
  }
}
