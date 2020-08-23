part of dart_express;

class _AppSettings {
  bool cache;
  String viewsPath;
  String viewEngine;

  _AppSettings({
    this.cache = true,
    String viewsPath,
    this.viewEngine = 'html',
  }) : viewsPath = viewsPath ?? path.absolute('views');
}

class App {
  _AppSettings _settings;
  Map<String, dynamic> cache;
  Map<String, Engine> _engines;
  HttpServer _server;
  Router _router;

  App() {
    _settings = _AppSettings();
    cache = {};
    _engines = {'html': HtmlEngine.use()};
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
  void set(String key, dynamic value) {
    switch (key.toLowerCase()) {
      case 'views engine':
      case 'view engine':
        _settings.viewEngine = value;
        break;
      case 'views':
        _settings.viewsPath = value;
        break;
      case 'cache':
        _settings.cache = !!value;
        break;
      default:
        throw ArgumentError('Invalid key "${key}" for settings.');
    }
  }

  /// Add a middleware callback for every request using this command
  ///
  /// Useful for parsing JSON, form data, logging requests, etc.
  App use(Function cb) {
    _lazyRouter();

    _router.use(cb);

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

    if (_engines[engine.ext] != null) {
      throw Error.safeToString(
        'A View engine for the ${engine.ext} extension has already been defined.',
      );
    }

    _engines[engine.ext] = engine;

    return this;
  }

  /// Handles DELETE requests to the specified path
  Route delete(String path, Function cb) =>
      _buildRoute(path, cb, _HTTPMethods.DELETE);

  /// Handles GET requests to the specified path
  Route get(String path, RouteMethod cb) =>
      _buildRoute(path, cb, _HTTPMethods.GET);

  /// Handles HEAD requests to the specified path
  Route head(String path, RouteMethod cb) =>
      _buildRoute(path, cb, _HTTPMethods.HEAD);

  /// Handles PATCH requests to the specified path
  Route patch(String path, RouteMethod cb) =>
      _buildRoute(path, cb, _HTTPMethods.PATCH);

  /// Handles POST requests to the specified path
  Route post(String path, RouteMethod cb) =>
      _buildRoute(path, cb, _HTTPMethods.POST);

  /// Handles PUT requests to the specified path
  Route put(String path, RouteMethod cb) =>
      _buildRoute(path, cb, _HTTPMethods.PUT);

  /// Handles ALL requests to the specified path
  List<Route> all(String path, RouteMethod cb) {
    final routes = <Route>[];

    _HTTPMethods.ALL.forEach((method) {
      routes.add(_buildRoute(path, cb, method));
    });

    return routes;
  }

  /// Starts the HTTP server listening on the specified port
  ///
  /// All Request and Response objects will be wrapped and handled by the Router
  void listen({InternetAddress address, int port, Function(int) cb}) async {
    _server = await HttpServer.bind(
      address ?? InternetAddress.loopbackIPv4,
      port,
    );

    _server.listen((HttpRequest req) {
      var request = Request(req);
      var response = Response(req.response, this);

      _router.handle(request, response);
    });

    if (cb != null) {
      cb(_server.port);
    }
  }

  void render(
    String fileName,
    Map<String, dynamic> options,
    Function callback,
  ) {
    try {
      _settings.cache ??= true;

      final view = _getViewFromFileName(fileName);

      view.render(options, callback);
    } catch (err) {
      callback(err);
    }
  }

  Route _buildRoute(path, cb, method) {
    _lazyRouter();

    final route = _router.route(path, method);

    return route;
  }

  Router _lazyRouter() {
    return _router ??= Router().use(_Middleware.init);
  }

  View _getViewFromFileName(String fileName) {
    View view;

    if (_settings.cache) {
      view = cache[fileName];
    }

    if (view == null) {
      view = View(
        fileName,
        defaultEngine: _settings.viewEngine,
        engines: _engines,
        rootPath: _settings.viewsPath,
      );

      if (view.filePath == null) {
        String dirs;

        if (view.rootPath is List) {
          dirs =
              'directories "${view.rootPath.join(', ')}" or "${view.rootPath[view.rootPath.length - 1]}"';
        } else {
          dirs = 'directory "${view.rootPath}"';
        }

        throw _ViewException(view, dirs);
      }

      if (_settings.cache) {
        cache[fileName] = view;
      }
    }

    return view;
  }
}
