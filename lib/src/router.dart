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

  Route route(String path) {
    var route = Route(path);
    var layer = Layer(path: path, handle: route.dispatch, route: route);

    this.stack.add(layer);

    return route;
  }

  handle(HttpRequest req, HttpResponse res, { Next next }) {
    this.stack.first.route.stack.first.handleRequest(req, res, next: next);
  }
}
