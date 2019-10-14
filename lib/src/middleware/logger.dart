import 'dart:io';

import 'package:dart_express/dart_express.dart';

class Logger {
  static RouteMethod use([Map<String, dynamic> options = const {}]) {
    bool immediate = options['immediate'] ?? false;
    var skip = options['skip'] ?? false;

    return (Request req, Response res) {
      req.startTime = DateTime.now();

      logRequest() {
        if (skip != false) {
          return;
        }

        var line = _formatLine(req, res);

        if (line == null) {
          return;
        }
        print(line);
      }

      if (immediate) {
        logRequest();
      } else {
        res.onDone((Response r) {
          logRequest();
        });
      }

      req.next();
    };
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
