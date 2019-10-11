import 'dart:io';

import 'package:dart_express/src/route.dart';

class Layer {
  String method;
  Function handle;
  Route route;

  String get name => '<anonymous>';

  Layer({ this.method, this.handle, this.route });

  match(path) {
    if (this.route == null) { return false; }

    return this.route.path == path;
  }

  handleRequest(HttpRequest req, HttpResponse res, { Next next }) {
    try {
      this.handle(req, res, next);
    } catch (err) {
      print(err);
    }
  }

  @override
  String toString() {
    return 'Layer: { path: ${this.route.path} }';
  }
}