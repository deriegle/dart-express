part of dart_express;

class _AppSettings {
  bool cache;
  bool printRoutes;
  String viewsPath;
  String viewEngine;

  _AppSettings({
    this.cache = true,
    String viewsPath,
    this.printRoutes = false,
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
      case 'print routes':
      case 'view routes':
      case 'show routes':
        _settings.printRoutes = value;
        break;
      default:
        throw ArgumentError('Invalid key "$key" for settings.');
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

  App useRouter(String path, Router router) {
    final currentRouter = _lazyRouter();

    currentRouter.stack.addAll(
      router.stack.map((layer) => layer.withPathPrefix(path)),
    );

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
  _Route delete(String path, Function cb) =>
      _buildRoute(path, _HTTPMethods.delete, cb);

  /// Handles GET requests to the specified path
  _Route get(String path, RouteMethod cb) =>
      _buildRoute(path, _HTTPMethods.get, cb);

  /// Handles HEAD requests to the specified path
  _Route head(String path, RouteMethod cb) =>
      _buildRoute(path, _HTTPMethods.head, cb);

  /// Handles PATCH requests to the specified path
  _Route patch(String path, RouteMethod cb) =>
      _buildRoute(path, _HTTPMethods.patch, cb);

  /// Handles POST requests to the specified path
  _Route post(String path, RouteMethod cb) =>
      _buildRoute(path, _HTTPMethods.post, cb);

  /// Handles PUT requests to the specified path
  _Route put(String path, RouteMethod cb) =>
      _buildRoute(path, _HTTPMethods.put, cb);

  /// Handles ALL requests to the specified path
  List<_Route> all(String path, RouteMethod cb) {
    final routes = <_Route>[];

    for (final method in _HTTPMethods.all) {
      routes.add(_buildRoute(path, method, cb));
    }

    return routes;
  }

  /// Starts the HTTP server listening on the specified port
  ///
  /// All Request and Response objects will be wrapped and handled by the Router
  Future<void> listen(
      {InternetAddress address, int port, Function(int) cb}) async {
    _server = await HttpServer.bind(
      address ?? InternetAddress.loopbackIPv4,
      port,
    );

    _mapToRoutes(cb);
  }

  /// Starts the HTTPS server listening on the specified port
  ///
  /// All Request and Response objects will be wrapped and handled by the Router
  ///
  /// You can add Certifications to the [SecurityContext]
  Future<void> listenHttps(
    SecurityContext securityContext, {
    InternetAddress address,
    int port,
    Function(int) cb,
  }) async {
    _server = await HttpServer.bindSecure(
        address ?? InternetAddress.loopbackIPv4, port, securityContext);

    _mapToRoutes(cb);
  }

  void _mapToRoutes(Function(int) cb) {
    _server.listen((HttpRequest req) {
      final request = Request(req);
      final response = Response(req.response, this);

      _router.handle(request, response);
    });

    if (_settings.printRoutes) {
      _printRoutes();
    }

    if (cb != null) {
      cb(_server.port);
    }
  }

  /// Render a template using the given filename and options
  ///
  /// Uses the extension "html" or the "view engine" default when not given an extension
  /// You can override the default by providing an extension
  /// Provide a Map of local variables to the template
  void render(
    String fileName,
    Map<String, dynamic> locals,
    Function callback,
  ) {
    _settings.cache ??= true;

    final view = _getViewFromFileName(fileName);

    view.render(locals, callback);
  }

  void _printRoutes() {
    _router.stack.where((layer) => layer.route != null).forEach((layer) {
      print('[${layer.method}] ${layer.path}');
    });
  }

  _Route _buildRoute(String path, String method, RouteMethod cb) =>
      _lazyRouter().route(path, method, cb);

  Router _lazyRouter() => _router ??= Router().use(_InitMiddleware.init);

  _View _getViewFromFileName(String fileName) {
    _View view;

    if (_settings.cache) {
      view = cache[fileName];
    }

    if (view == null) {
      view = _View(
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
