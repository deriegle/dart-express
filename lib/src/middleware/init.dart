part of dart_express;

class _InitMiddleware {
  static final String name = 'EXPRESS_INIT';

  static void init(Request req, Response res) {
    req.next();
  }
}
