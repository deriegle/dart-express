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
  List<Layer> stack = [];
  RouterOptions options;

  Router({this.options = const RouterOptions()});

  Route route(String path, String method) {
    final route = Route(path);

    stack.add(Layer(path, method: method, handle: (req, res) {}, route: route));

    return route;
  }

  Router use(RouteMethod cb) {
    var layer = Layer('/', handle: cb, name: _Middleware.name);

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
      Layer layer;
      var match = false;
      Route route;

      while (match != true && index < stack.length) {
        layer = stack[index++];
        match = matchLayer(layer, path, method);
        route = layer.route;

        if (match != true) {
          continue;
        }

        if (!(route is Route)) {
          continue;
        }

        req.params.addAll(layer.routeParams);

        route.stack.first.handleRequest(req, res);
      }

      // Matched without a route (Initial Middleware)
      if (match && route == null) {
        layer.handleRequest(req, res);
      }
    };

    req.next();
  }

  bool matchLayer(Layer layer, String path, String method) {
    try {
      return layer.match(path, method);
    } catch (err) {
      return err;
    }
  }
}
