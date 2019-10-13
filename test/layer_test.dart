import 'package:dart_express/src/layer.dart';
import 'package:dart_express/src/request.dart';
import 'package:dart_express/src/response.dart';
import 'package:dart_express/src/route.dart';
import 'package:dart_express/src/middleware/init.dart';
import 'package:test/test.dart';

void main() {
  Layer layer;

  group('Route matching', () {
    Route route;

    test('unconditionally matches when the name of the handler is the same as the initial middleware', () {
      layer = Layer('/', name: Middleware.name);

      expect(layer.match('/'), isTrue);
      expect(layer.match('/random_not_matching_route'), isTrue);
    });

    test('matches when the routes are the same', () {
      route = Route('/my_route');
      layer = Layer('/my_route', route: route);

      expect(layer.match('/'), isFalse);
      expect(layer.match('/route'), isFalse);
      expect(layer.match('/my_route'), isTrue);
    });

    test('does not match when route is not given', () {
      layer = Layer('/my_route', route: null);

      expect(layer.match('/'), isFalse);
      expect(layer.match('/route'), isFalse);
      expect(layer.match('/my_route'), isFalse);
    });
  });

  group('route handling', () {
    test('calls the handler method with the expected values', () {
      bool called = false;

      mockHandler(Request request, Response res, Function next) {
        called = true;
      }

      layer = Layer('/', handle: mockHandler);

      var req = Request(null);
      var res = Response(null, null);

      layer.handleRequest(req, res, () {});

      expect(called, isTrue);
    });
  });
}