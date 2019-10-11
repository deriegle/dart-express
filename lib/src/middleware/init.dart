import 'dart:io';

class Middleware {
  static final String name = 'EXPRESS_INIT';

  static init(HttpRequest req, HttpResponse res, Function next) {
    print('$name middleware');

    next();
  }
}
