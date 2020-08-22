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
  _AppSettings _settings;
  Map<String, dynamic> cache;
  Map<String, Engine> _engines;
  HttpServer _server;
  Router _router;

  App() {
    this._settings = _AppSettings();
    this.cache = {};
    this._engines = {'html': HtmlEngine.use()};
  }

  /// Set App configuration values
  ///
  /// Acceptable keys: 'views engine', 'views', and 'cache'
  ///
  /// Cache [Default: true]
  ///
  /// This key takes a boolean value to determine whether we should cache pages or not
  ///
  /// View Engine [Default: html]
  ///
  /// This key takes a string value of the extension of the default view engine you'd like to use.
  /// For Example: Provide "jael" for Jael templates as your default
  ///
  /// Views [Default: ./views]
  ///
  /// This key takes a string value of the file path to the views folder
  set(String key, dynamic value) {
    switch (key.toLowerCase()) {
      case 'views engine':
      case 'view engine':
        this._settings.viewEngine = value;
        break;
      case 'views':
        this._settings.viewsPath = value;
        break;
      case 'cache':
        this._settings.cache = !!value;
        break;
      default:
        throw ArgumentError('Invalid key "${key}" for settings.');
    }
  }

  /// Add a middleware callback for every request using this command
  ///
  /// Useful for parsing JSON, form data, logging requests, etc.
  use(Function cb) {
    this._lazyRouter();

    this._router.use(cb);

    return this;
  }

  /// Adds new View Engine to App
  ///
  /// Examples:
  ///
  /// app.engine(JaelEngine.use());
  ///
  /// app.engine(MustacheEngine.use());
  ///
  /// app.engine(MarkdownEngine.use());
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

  /// Handles DELETE requests to the specified path
  Route delete(String path, Function cb) =>
      _buildRoute(path, cb, HTTPMethods.DELETE);

  /// Handles GET requests to the specified path
  Route get(String path, RouteMethod cb) =>
      _buildRoute(path, cb, HTTPMethods.GET);

  /// Handles HEAD requests to the specified path
  Route head(String path, RouteMethod cb) =>
      _buildRoute(path, cb, HTTPMethods.HEAD);

  /// Handles PATCH requests to the specified path
  Route patch(String path, RouteMethod cb) =>
      _buildRoute(path, cb, HTTPMethods.PATCH);

  /// Handles POST requests to the specified path
  Route post(String path, RouteMethod cb) =>
      _buildRoute(path, cb, HTTPMethods.POST);

  /// Handles PUT requests to the specified path
  Route put(String path, RouteMethod cb) =>
      _buildRoute(path, cb, HTTPMethods.PUT);

  /// Handles READ requests to the specified path
  Route read(String path, RouteMethod cb) =>
      _buildRoute(path, cb, HTTPMethods.READ);

  /// Handles ALL requests to the specified path
  List<Route> all(String path, RouteMethod cb) {
    List<Route> routes = [];

    HTTPMethods.ALL.forEach((method) {
      routes.add(_buildRoute(path, cb, method));
    });

    return routes;
  }

  /// Starts the HTTP server listening on the specified port
  ///
  /// All Request and Response objects will be wrapped and handled by the Router
  listen({InternetAddress address, int port, Function(int) cb}) async {
    this._server = await HttpServer.bind(
      address ?? InternetAddress.loopbackIPv4,
      port,
    );

    this._server.listen((HttpRequest req) {
      var request = Request(req);
      var response = Response(req.response, this);

      this._router.handle(request, response);
    });

    if (cb != null) {
      cb(this._server.port);
    }
  }

  render(String fileName, Map<String, dynamic> options, Function callback) {
    View view;

    if (this._settings.cache == null) {
      this._settings.cache = true;
    }

    if (this._settings.cache) {
      view = this.cache[fileName];
    }

    if (view == null) {
      view = View(
        fileName,
        defaultEngine: this._settings.viewEngine,
        engines: this._engines,
        rootPath: this._settings.viewsPath,
      );

      if (view.filePath == null) {
        String dirs;

        if (view.rootPath is List) {
          dirs =
              'directories "${view.rootPath.join(', ')}" or "${view.rootPath[view.rootPath.length - 1]}"';
        } else {
          dirs = 'directory "${view.rootPath}"';
        }

        var err = Error.safeToString(
            'Failed to lookup view "${view.name}${view.ext}" in views $dirs');
        return callback(err, null);
      }

      if (this._settings.cache) {
        this.cache[fileName] = view;
      }
    }

    this._tryRender(view, options, callback);
  }

  _buildRoute(path, cb, method) {
    this._lazyRouter();

    var route = this._router.route(path, method);
    route.read(cb);

    return route;
  }

  _lazyRouter() {
    if (this._router == null) {
      this._router = Router().use(Middleware.init);
    }
  }

  _tryRender(View view, Map<String, dynamic> options, Function callback) {
    try {
      view.render(options, callback);
    } catch (err) {
      callback(err);
    }
  }
}
