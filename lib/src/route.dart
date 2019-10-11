import 'dart:io';
import 'layer.dart';

typedef Next = Function();
typedef RouteMethod = Function(HttpRequest req, HttpResponse res, Next next);

class Route {
  final String path;
  final List<Layer> stack = [];
  Map<String, dynamic> methods = {};

  Route(this.path);

  dispatch(HttpRequest req, HttpResponse res, Next next) {}

  delete(RouteMethod cb) {
    this._setLayer('delete', cb);
  }

  get(RouteMethod cb) {
    this._setLayer('get', cb);
  }

  head(RouteMethod cb) {
    this._setLayer('head', cb);
  }

  patch(RouteMethod cb) {
    this._setLayer('patch', cb);
  }

  post(RouteMethod cb) {
    this._setLayer('post', cb);
  }

  put(RouteMethod cb) {
    this._setLayer('put', cb);
  }

  read(RouteMethod cb) {
    this._setLayer('read', cb);
  }

  _setLayer(String method, RouteMethod cb) {
    var layer = Layer(
      null,
      method: method,
      handle: cb,
      route: this
    );

    this.methods[method] = true;

    this.stack.add(layer);
  }
}
