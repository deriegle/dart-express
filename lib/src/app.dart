import 'dart:io' show HttpServer, InternetAddress, HttpRequest;
import 'package:dart_express/src/engines/html.dart';
import 'package:dart_express/src/middleware/init.dart';
import 'package:dart_express/src/route.dart';
import 'package:dart_express/src/router.dart';
import 'package:dart_express/src/response.dart';
import 'package:dart_express/src/request.dart';
import 'package:dart_express/src/http_methods.dart';
import 'package:dart_express/src/engines/engine.dart';
import 'package:dart_express/src/view.dart';
import 'package:path/path.dart' as path show absolute;

class _AppSettings {
  bool cache;
  String viewsPath;
  String viewEngine;

  _AppSettings({
    this.cache = true,
    this.viewsPath,
    this.viewEngine = 'html',
  }) {
    this.viewsPath = this.viewsPath ?? path.absolute('views');
  }
}

class App {
  _AppSettings settings;
  Map<String, dynamic> cache;
  Map<String, Engine> _engines;
  HttpServer _server;
  Router _router;

  App({this.settings}) {
    this.settings = this.settings ?? _AppSettings();
    this.cache = {};
    this._engines = {
      'html': HtmlEngine.use(),
    };
  }

  set(String key, dynamic value) {
    switch (key.toLowerCase()) {
      case 'views engine':
      case 'view engine':
        this.settings.viewEngine = value;
        break;
      case 'views':
        this.settings.viewsPath = value;
        break;
      default:
        throw ArgumentError('Invalid key "${key}" for settings.');
    }
  }

  use(Function cb) {
    this.lazyRouter();

    this._router.use(cb);

    return this;
  }

  App engine(Engine engine) {
    if (engine.ext == null) {
      throw Error.safeToString('Engine extension must be defined.');
    }

    if (this._engines[engine.ext] != null) {
      throw Error.safeToString(
          'A View engine for the ${engine.ext} extension has already been defined.');
    }

    this._engines[engine.ext] = engine;

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
      var response = Response(req.response, this);

      this.handle(request, response);
    });

    if (cb != null) {
      cb(this._server.port);
    }
  }

  handle(Request req, Response res) {
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

  render(String fileName, Map<String, dynamic> options, Function callback) {
    View view;

    if (this.settings.cache == null) {
      this.settings.cache = true;
    }

    if (this.settings.cache) {
      view = this.cache[fileName];
    }

    if (view == null) {
      view = View(
        fileName,
        defaultEngine: this.settings.viewEngine,
        engines: this._engines,
        rootPath: this.settings.viewsPath,
      );

      if (view.filePath == null) {
        String dirs;

        if (view.rootPath is List) {
          dirs =
              'directories "${view.rootPath.join(', ')}" or "${view.rootPath[view.rootPath.length - 1]}"';
        } else {
          dirs = 'directory "${view.rootPath}"';
        }

        var err =
            Error.safeToString('Failed to lookup view "${view.name}${view.ext}" in views $dirs');
        return callback(err, null);
      }

      if (this.settings.cache) {
        this.cache[fileName] = view;
      }
    }

    this._tryRender(view, options, callback);
  }

  _tryRender(View view, Map<String, dynamic> options, Function callback) {
    try {
      view.render(options, callback);
    } catch (err) {
      callback(err);
    }
  }
}
