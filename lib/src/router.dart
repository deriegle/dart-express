import 'dart:io';
import 'package:dart_express/src/route.dart';
import 'package:dart_express/src/layer.dart';
import 'package:dart_express/src/middleware/init.dart';

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
    var route = Route(path);
    var layer = Layer(path, method: method, handle: route.dispatch, route: route);

    this.stack.add(layer);

    return route;
  }

  Router use(Function cb) {
    var layer = Layer('/', handle: cb, name: Middleware.name);

    this.stack.add(layer);

    return this;
  }

  handle(HttpRequest req, HttpResponse res) {
    var self = this;
    var stack = self.stack;
    var index = 0;

    next() {
      var path = req.requestedUri.path;
      bool match = false;
      Layer layer;
      Route route;

      while(match != true && index < stack.length) {
        layer = stack[index++];
        match = matchLayer(layer, path);
        route = layer.route;

        if (match != true) { continue; }
        if (route == null) { continue; }

        route.stack.first.handleRequest(req, res, next);
      }

      if (match) {
        print('how many times does this fall through');
        layer.handleRequest(req, res, next);
      }
    }

    next();
  }

  matchLayer(Layer layer, String path) {
    try {
      return layer.match(path);
    } catch(err) {
      return err;
    }
  }
}
