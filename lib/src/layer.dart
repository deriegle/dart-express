import 'package:dart_express/src/request.dart';
import 'package:path_to_regexp/path_to_regexp.dart';
import 'package:dart_express/src/response.dart';
import 'middleware/init.dart';
import 'package:dart_express/src/route.dart';

class Layer {
  String _path;
  String method;
  RouteMethod handle;
  Route route;
  String name;
  RegExp regExp;
  List<String> parameters;
  Map<String, dynamic> routeParams;

  String get path => this._path ?? this.route.path;

  Layer(this._path, {this.method, this.handle, this.route, this.name}) {
    this.name = this.name ?? '<anonymous>';
    this.parameters = [];
    this.regExp = pathToRegExp(this.path, parameters: this.parameters);
    this.routeParams = {};
  }

  match(String pathToCheck, String methodToCheck) {
    if (this._doesPathMatch(pathToCheck) && this.method != null && this.method.toUpperCase() == methodToCheck.toUpperCase()) {
      if (this.parameters.isNotEmpty) {
        final match = this.regExp.matchAsPrefix(pathToCheck);
        this.routeParams = extract(parameters, match);
      }

      return true;
    } else if (this.name == Middleware.name) {
      return true;
    }

    return false;
  }

  handleRequest(Request req, Response res, Next next) {
    this.handle(req, res, next);
  }

  @override
  String toString() {
    return 'Layer: { path: ${this.route.path} }';
  }

  bool _doesPathMatch(String pathToCheck) {
    if (this.route == null || this.path == null) {
      return false;
    }

    if (this.regExp.hasMatch(pathToCheck)) {
      return true;
    } else if (this.path == pathToCheck) {
      return true;
    }

    return false;
  }
}
