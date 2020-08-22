import 'layer.dart';
import 'package:dart_express/src/request.dart';
import 'package:dart_express/src/response.dart';

typedef Next = Function();
typedef RouteMethod = Function(Request req, Response res);

class Route {
  final String path;
  final List<Layer> stack = [];

  Route(this.path);

  void delete(RouteMethod cb) => _setLayer('delete', cb);
  void get(RouteMethod cb) => _setLayer('get', cb);
  void head(RouteMethod cb) => _setLayer('head', cb);
  void patch(RouteMethod cb) => _setLayer('patch', cb);
  void post(RouteMethod cb) => _setLayer('post', cb);
  void put(RouteMethod cb) => _setLayer('put', cb);
  void read(RouteMethod cb) => _setLayer('read', cb);

  void _setLayer(String method, RouteMethod cb) =>
      stack.add(Layer(null, method: method, handle: cb, route: this));
}
