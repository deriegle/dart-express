import 'dart:io';
import 'package:dart_express/src/middleware/init.dart';
import 'package:dart_express/src/route.dart';
import 'package:dart_express/src/router.dart';
import 'package:dart_express/src/response.dart';
import 'package:dart_express/src/request.dart';

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

  use(Function cb) {
    this.lazyRouter();

    this._router.use(cb);

    return this;
  }

  Route delete(String path, Function cb) => buildRoute(path, cb, 'delete');
  Route get(String path, RouteMethod cb) => buildRoute(path, cb, 'get');
  Route head(String path, RouteMethod cb) => buildRoute(path, cb, 'head');
  Route patch(String path, RouteMethod cb) => buildRoute(path, cb, 'patch');
  Route post(String path, RouteMethod cb) => buildRoute(path, cb, 'post');
  Route put(String path, RouteMethod cb) => buildRoute(path, cb, 'put');
  Route read(String path, RouteMethod cb) => buildRoute(path, cb, 'read');
  Route all(String path, RouteMethod cb) => buildRoute(path, cb, null);

  listen(int port, [Function(int) cb]) async {
    this._server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);

    this._server.listen((HttpRequest req) {
      var request = Request(req);
      var response = Response(req.response);

      this.handle(request, response);
    });

    if (cb != null) {
      cb(this._server.port);
    }
  }

  handle(HttpRequest req, HttpResponse res) {
    this._router.handle(req, res);
  }

  buildRoute(path, cb, method) {
    this.lazyRouter();

    var route = this._router.route(path, method);
    route.read(cb);

    return route;
  }

  lazyRouter() {
    if (this._router == null) {
      this._router = Router().use(Middleware.init);
    }
  }
}
