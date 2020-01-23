import 'dart:io';

import 'package:dart_express/dart_express.dart';

enum LoggerOptions { includeImmediate }

class Logger {
  static RouteMethod use([List<LoggerOptions> options]) {
    return (Request req, Response res) {
      req.startTime = DateTime.now();

      if (options != null && options.contains(LoggerOptions.includeImmediate)) {
        logRequest(req, res);
      } else {
        res.onDone((Response r) {
          logRequest(req, r);
        });
      }

      req.next();
    };
  }

  static void logRequest(Request request, Response response) {
    var line = _formatLine(request, response);

    if (line != null) {
      print(line);
    }
  }

  static String _formatLine(Request req, Response res) {
    var remoteAddr = _getIp(req).address;
    var startTime = req.startTime;
    var method = req.method;
    var url = req.requestedUri;
    var status = res.statusCode;
    var contentLength = res.headers.contentLength;
    var referrer = req.headers['referrer'] ?? req.headers['referer'];
    var userAgent = req.headers['user-agent'];

    return "${remoteAddr} [${startTime}] \"${method} ${url}\" ${status} ${contentLength} \"${referrer}\" \"${userAgent}\"";
  }

  static InternetAddress _getIp(Request req) {
    return req.connectionInfo.remoteAddress;
  }
}
