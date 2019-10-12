import 'dart:io';
import 'package:dart_express/src/middleware/init.dart';
import 'package:dart_express/src/route.dart';
import 'package:dart_express/src/router.dart';
import 'package:dart_express/src/response.dart';
import 'package:dart_express/src/request.dart';
import 'package:dart_express/src/http_methods.dart';

class AppSettings {
  String viewsPath;

  AppSettings({this.viewsPath = './views'});
}

class App {
  AppSettings settings;
  HttpServer _server;
  Router _router;

  App({this.settings}) {
    this.settings = this.settings ?? AppSettings();
  }

  use(Function cb) {
    this.lazyRouter();

    this._router.use(cb);

    return this;
  }

  Route delete(String path, Function cb) => buildRoute(path, cb, HTTPMethods.DELETE);
  Route get(String path, RouteMethod cb) => buildRoute(path, cb, HTTPMethods.GET);
  Route head(String path, RouteMethod cb) => buildRoute(path, cb, HTTPMethods.HEAD);
  Route patch(String path, RouteMethod cb) => buildRoute(path, cb, HTTPMethods.PATCH);
  Route post(String path, RouteMethod cb) => buildRoute(path, cb, HTTPMethods.POST);
  Route put(String path, RouteMethod cb) => buildRoute(path, cb, HTTPMethods.PUT);
  Route read(String path, RouteMethod cb) => buildRoute(path, cb, HTTPMethods.READ);

  List<Route> all(String path, RouteMethod cb) {
    List<Route> routes = [];

    HTTPMethods.ALL.forEach((method) {
      routes.add(buildRoute(path, cb, method));
    });

    return routes;
  }

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
