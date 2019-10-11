import 'dart:io';
import 'middleware/init.dart';
import 'package:dart_express/src/route.dart';

class Layer {
  String _path;
  String method;
  RouteMethod handle;
  Route route;
  String name;

  String get path => this._path ?? this.route.path;

  Layer(this._path, { this.method, this.handle, this.route, this.name }) {
    this.name = this.name ?? '<anonymous>';
  }

  match(pathToCheck) {
    if (this.name == Middleware.name) {
      return true;
    }

    if (this.route == null) { return false; }

    return this.route.path == pathToCheck;
  }

  handleRequest(HttpRequest req, HttpResponse res, Next next) {
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
