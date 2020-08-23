part of dart_express;

class BodyParser {
  static RouteMethod json() {
    return (Request req, Response res) {
      final contentType = req.headers.contentType;

      if (req.method == 'POST' &&
          contentType != null &&
          contentType.mimeType == 'application/json') {
        convertBodyToJson(req).then((Map<String, dynamic> json) {
          if (json != null) {
            req.body = json;
          }

          req.next();
        });
      } else {
        req.next();
      }
    };
  }

  static Future<Map<String, dynamic>> convertBodyToJson(Request request) async {
    try {
      final content = await convert.utf8.decoder.bind(request.request).join();

      return convert.jsonDecode(content) as Map<String, dynamic>;
    } catch (e) {
      print(e);

      return null;
    }
  }
}
