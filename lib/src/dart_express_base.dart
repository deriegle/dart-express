import 'package:dart_express/src/router.dart';
import 'package:dart_express/src/route.dart';
import 'dart:io';

App express() {
  return App();
}

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

  delete(String path, Function cb) {
    this.lazyRouter();

    var route = this._router.route(path, 'delete');
    route.delete(cb);
    return route;
  }

  get(String path, RouteMethod cb) {
    this.lazyRouter();

    var route = this._router.route(path, 'get');
    route.get(cb);

    return route;
  }

  head(String path, RouteMethod cb) {
    this.lazyRouter();

    var route = this._router.route(path, 'head');
    route.head(cb);
    return route;
  }

  patch(String path, RouteMethod cb) {
    this.lazyRouter();

    var route = this._router.route(path, 'patch');
    route.patch(cb);

    return route;
  }

  post(String path, RouteMethod cb) {
    this.lazyRouter();

    var route = this._router.route(path, 'post');
    route.post(cb);

    return route;
  }

  put(String path, RouteMethod cb) {
    this.lazyRouter();

    var route = this._router.route(path, 'put');
    route.put(cb);

    return route;
  }

  read(String path, RouteMethod cb) {
    this.lazyRouter();

    var route = this._router.route(path, 'read');
    route.read(cb);

    return route;
  }

  listen(int port, [Function(int) cb]) async {
    this._server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);

    this._server.listen((HttpRequest req) {
      this.handle(req, req.response);
    });

    print("Address: ${this._server.address}");

    if (cb != null) {
      cb(this._server.port);
    }
  }

  handle(HttpRequest req, HttpResponse res, { Next next }) {
    this._router.handle(req, res);
  }

  lazyRouter() {
    if (this._router == null) {
      this._router = Router();
    }
  }
}