import 'dart:io';
import 'package:dart_express/src/app.dart';

class Middleware {
  static final String name = 'EXPRESS_INIT';

  static init(App app) {
    return (HttpRequest req, HttpResponse res, Function next) {
      print('MIDDLE WARE');

      next();
    };
  }

}

var middleware = Middleware();
