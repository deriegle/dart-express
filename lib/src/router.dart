part of dart_express;

class RouterOptions {
  final bool caseSensitive;
  final bool mergeParams;
  final bool strict;

  const RouterOptions({
    this.caseSensitive = false,
    this.mergeParams = false,
    this.strict = false,
  });
}

class Router {
  Map<dynamic, dynamic> params = const {};
  List<_Layer> stack = [];
  RouterOptions options;

  Router({this.options = const RouterOptions()});

  _Route route(String path, String method, RouteMethod handle) {
    final route = _Route(path);

    stack.add(
      _Layer(
        path,
        method: method,
        handle: handle,
        route: route,
      ),
    );

    return route;
  }

  /// Handles DELETE requests to the specified path
  _Route delete(String path, Function cb) => route(
      path, _HTTPMethods.delete, cb as dynamic Function(Request, Response));

  /// Handles GET requests to the specified path
  _Route get(String path, RouteMethod cb) => route(path, _HTTPMethods.get, cb);

  /// Handles HEAD requests to the specified path
  _Route head(String path, RouteMethod cb) =>
      route(path, _HTTPMethods.head, cb);

  /// Handles PATCH requests to the specified path
  _Route patch(String path, RouteMethod cb) =>
      route(path, _HTTPMethods.patch, cb);

  /// Handles POST requests to the specified path
  _Route post(String path, RouteMethod cb) =>
      route(path, _HTTPMethods.post, cb);

  /// Handles PUT requests to the specified path
  _Route put(String path, RouteMethod cb) => route(path, _HTTPMethods.put, cb);

  /// Handles ALL requests to the specified path
  List<_Route> all(String path, RouteMethod cb) {
    final routes = <_Route>[];

    for (final method in _HTTPMethods.all) {
      routes.add(route(path, method, cb));
    }

    return routes;
  }

  Router use(RouteMethod handle) {
    final layer = _Layer(
      '/',
      handle: handle,
      name: _InitMiddleware.name,
    );

    stack.add(layer);

    return this;
  }

  void handle(Request req, Response res) {
    Router self = this;
    final stack = self.stack;
    int index = 0;

    req.next = () {
      final path = req.requestedUri.path;
      final method = req.method;

      // find next matching layer
      late _Layer layer;
      var match = false;
      _Route? route;

      while (match != true && index < stack.length) {
        layer = stack[index++];
        match = matchLayer(layer, path, method);
        route = layer.route;

        if (!match || route is! _Route) {
          continue;
        }

        req.params.addAll(layer.routeParams);

        if (route.stack.isNotEmpty) {
          route.stack.first.handleRequest(req, res);
        } else {
          layer.handleRequest(req, res);
        }
      }

      // Matched without a route (Initial Middleware)
      if (match && route == null) {
        layer.handleRequest(req, res);
      }
    };

    req.next();
  }

  bool matchLayer(_Layer layer, String path, String method) {
    try {
      return layer.match(path, method);
    } catch (err) {
      print('Error while matching route: $err');
      return false;
    }
  }
}
