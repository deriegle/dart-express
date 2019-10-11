import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dart_express/src/route.dart';
import 'package:dart_express/src/layer.dart';

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
    var layer = Layer(method: method, handle: route.dispatch, route: route);

    this.stack.add(layer);

    return route;
  }

  handle(HttpRequest req, HttpResponse res, { Next next }) {
    var path = req.requestedUri.path;

    bool match = false;
    Layer layer;
    Route route;
    var index = 0;

    while(match != true && index < this.stack.length) {
      layer = this.stack[index++];
      match = matchLayer(layer, path);
      route = layer.route;

      if (match != true || route == null) {
        continue;
      }

      if (layer != null) {
        layer = route.stack.firstWhere((l) => l.method.toUpperCase() == req.method.toUpperCase());

        return layer.handleRequest(req, res, next: next);
      }
    }

    res.statusCode = 404;
    res.close();
  }

  matchLayer(Layer layer, String path) {
    try {
      return layer.match(path);
    } catch(err) {
      return err;
    }
  }
}
