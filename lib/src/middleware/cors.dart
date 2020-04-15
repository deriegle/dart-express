import 'package:dart_express/src/request.dart';
import 'package:dart_express/src/response.dart';
import 'package:dart_express/src/route.dart';

class CorsMiddleware {
  static RouteMethod use() {
    return (Request req, Response res) {
      final origin = req.headers.value('origin');

      print(origin);

      req.next();
    };
  }
}
