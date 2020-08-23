part of dart_express;

class RouterOptions {
  final bool caseSensitive;
  final bool mergeParams;
  final bool strict;

  const RouterOptions(
      {this.caseSensitive = false,
      this.mergeParams = false,
      this.strict = false});
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
        handle: handle ?? (req, res) {},
        route: route,
      ),
    );

    return route;
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
    var self = this;
    var stack = self.stack;
    var index = 0;

    req.next = () {
      final path = req.requestedUri.path;
      final method = req.method;

      // find next matching layer
      _Layer layer;
      var match = false;
      _Route route;

      while (match != true && index < stack.length) {
        layer = stack[index++];
        match = matchLayer(layer, path, method);
        route = layer.route;

        if (!match || !(route is _Route)) {
          continue;
        }

        req.params.addAll(layer.routeParams);

        if (route.stack.isNotEmpty) {
          route.stack.first.handleRequest(req, res);
        } else if (layer.handle != null) {
          layer.handleRequest(req, res);
        } else {
          res.status(HttpStatus.notFound).close();
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
