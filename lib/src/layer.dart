import 'dart:io';

import 'package:dart_express/src/route.dart';

class Layer {
  String path;
  Function handle;
  Route route;

  String get name => '<anonymous>';

  Layer({ this.path, this.handle, this.route });

  match(path) {
    if (this.path != null) {
      return this.path == path;
    }

    if (this.route != null) {
      return this.route.path == path;
    }

    return false;
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
    return 'Layer: { path: ${this.path} }';
  }
}