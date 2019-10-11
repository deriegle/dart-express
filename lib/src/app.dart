import 'dart:io';
import 'package:dart_express/src/middleware/init.dart';
import 'package:dart_express/src/route.dart';
import 'package:dart_express/src/router.dart';

class App {
  HttpServer _server;
  Map cache;
  Map settings;
  Map engines;
  Router _router;

  App({
    this.cache,
    this.settings,
    this.engines,
  });

  Route delete(String path, Function cb) => buildRoute(path, cb, 'delete');

  Route get(String path, RouteMethod cb) => buildRoute(path, cb, 'get');

  Route head(String path, RouteMethod cb) => buildRoute(path, cb, 'head');

  Route patch(String path, RouteMethod cb) => buildRoute(path, cb, 'patch');

  Route post(String path, RouteMethod cb) => buildRoute(path, cb, 'post');

  Route put(String path, RouteMethod cb) => buildRoute(path, cb, 'put');

  Route read(String path, RouteMethod cb) => buildRoute(path, cb, 'read');

  listen(int port, [Function(int) cb]) async {
    this._server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);

    this._server.listen((HttpRequest req) {
      this.handle(req, req.response);
    });

    if (cb != null) {
      cb(this._server.port);
    }
  }

  handle(HttpRequest req, HttpResponse res, { Next next }) {
    this._router.handle(req, res);
  }

  buildRoute(path, cb, method) {
    this.lazyRouter();

    var route = this._router.route(path, 'read');
    route.read(cb);

    return route;
  }

  lazyRouter() {
    if (this._router == null) {
      this._router = Router();

      this._router.use(middleware.init(this));
    }
  }
}
