part of dart_express;

class LoggerMiddleware {
  static RouteMethod use({bool includeImmediate = false}) {
    return (Request req, Response res) {
      if (includeImmediate) {
        _logRequest(req, res);
      }

      res.isDone.then((successful) {
        _logRequest(req, res);
      });

      req.next();
    };
  }

  static void _logRequest(Request req, Response res) {
    print(_formatLine(req, res));
  }

  static String _formatLine(Request req, Response res) {
    final address = _getIpAddress(req);
    final method = req.method;
    final url = req.requestedUri;
    final status = res.statusCode;
    final contentLength = req.contentLength;
    final referrer =
        req.headers.value('referrer') ?? req.headers.value('referer') ?? '';
    final userAgent = req.headers.value('user-agent');

    return '$address "$method $url" $status $contentLength ${referrer.isNotEmpty ? '"$referrer"' : ''}"$userAgent"';
  }

  static String _getIpAddress(Request req) =>
      req.connectionInfo!.remoteAddress.address.toString();
}
