part of dart_express;

class Layer {
  final String _path;
  String method;
  RouteMethod handle;
  Route route;
  String name;
  RegExp regExp;
  List<String> parameters;
  Map<String, String> routeParams;

  String get path => _path ?? route.path;

  Layer(this._path, {this.method, this.handle, this.route, this.name}) {
    name = name ?? '<anonymous>';
    parameters = [];
    regExp = pathToRegExp(path, parameters: parameters);
    routeParams = {};
  }

  bool match(String pathToCheck, String methodToCheck) {
    if (_pathMatches(pathToCheck) &&
        method != null &&
        method.toUpperCase() == methodToCheck.toUpperCase()) {
      if (parameters.isNotEmpty) {
        final match = regExp.matchAsPrefix(pathToCheck);
        routeParams.addAll(extract(parameters, match));
      }

      return true;
    } else if (name == _InitMiddleware.name) {
      return true;
    }

    return false;
  }

  void handleRequest(Request req, Response res) => handle(req, res);

  @override
  String toString() {
    return 'Layer: { path: ${route.path} }';
  }

  bool _pathMatches(String pathToCheck) {
    if (route == null || path == null) {
      return false;
    }

    if (regExp.hasMatch(pathToCheck)) {
      return true;
    } else if (path == pathToCheck) {
      return true;
    }

    return false;
  }
}
