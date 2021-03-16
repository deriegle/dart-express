part of dart_express;

class _Layer {
  final String _path;
  String method;
  RouteMethod handle;
  _Route route;
  String name;
  RegExp regExp;
  List<String> parameters;
  Map<String, String> routeParams;

  String get path => _path ?? route.path;

  _Layer(this._path, {this.method, this.handle, this.route, this.name}) {
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

  _Layer withPathPrefix(String pathPrefix) {
    return _Layer(
      _joinPath(pathPrefix, path),
      method: method,
      handle: handle,
      route: route,
      name: name,
    );
  }

  String _joinPath(String pathPrefix, String path) {
    if (pathPrefix.endsWith('/') && path.startsWith('/')) {
      return pathPrefix + path.substring(1);
    } else if (pathPrefix.endsWith('/') || path.startsWith('/')) {
      return pathPrefix + path;
    } else {
      return pathPrefix + '/' + path;
    }
  }

  @override
  String toString() {
    return 'Layer: { path: $path }';
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
