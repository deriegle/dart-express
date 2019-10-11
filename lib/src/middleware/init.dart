import 'package:http/http.dart' as http;
import 'package:dart_express/src/app.dart';

class Middleware {
  init(App app) {
    return (http.Request req, http.Response res, Function next) {
      next();
    };
  }
}

var middleware = Middleware();
