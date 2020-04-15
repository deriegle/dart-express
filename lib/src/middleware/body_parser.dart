import 'dart:convert';
import 'package:dart_express/dart_express.dart';

class BodyParser {
  static RouteMethod json() {
    return (Request req, Response res) {
      var contentType = req.headers.contentType;

      if (req.method == 'POST' &&
          contentType != null &&
          contentType.mimeType == 'application/json') {
        convertBodyToJson(req).then((Map<String, dynamic> json) {
          req.body = json;

          req.next();
        });
      } else {
        req.next();
      }
    };
  }

  static Future<Map<String, dynamic>> convertBodyToJson(request) async {
    try {
      String content = await utf8.decoder.bind(request).join();

      return jsonDecode(content) as Map<String, dynamic>;
    } catch (e) {
      print(e);

      return null;
    }
  }
}
