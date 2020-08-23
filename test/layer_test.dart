import 'package:dart_express/dart_express.dart';
import 'package:test/test.dart';

void main() {
  Layer layer;
  String method;

  group('Route matching', () {
    Route route;

    setUp(() {
      method = 'get';
    });

    test('matches when the routes are the same', () {
      route = Route('/my_route');
      layer = Layer('/my_route', route: route, method: method);

      expect(layer.match('/', method), isFalse);
      expect(layer.match('/route', method), isFalse);
      expect(layer.match('/my_route', method), isTrue);
    });

    test('does not match when route is not given', () {
      layer = Layer('/my_route', route: null, method: method);

      expect(layer.match('/', method), isFalse);
      expect(layer.match('/route', method), isFalse);
      expect(layer.match('/my_route', method), isFalse);
    });

    test('does not match when the method is different', () {
      route = Route('/my_route');
      layer = Layer(null, route: route, method: method);

      expect(layer.match('/my_route', 'post'), isFalse);
      expect(layer.match('/my_route', 'put'), isFalse);
      expect(layer.match('/my_route', method), isTrue);
    });

    test('matches routes with params correctly', () {
      route = Route(null);
      layer = Layer('/posts/:postId', route: route, method: method);

      expect(layer.match('/posts/1', method), isTrue);
      expect(layer.parameters, equals(['postId']));
      expect(
          layer.routeParams,
          equals({
            'postId': '1',
          }));

      expect(layer.match('/users/1', method), isFalse);
    });

    test('matches advanced routes with params correctly', () {
      route = Route(null);
      layer =
          Layer('/users/:userId/posts/:postId', route: route, method: method);

      final userId = 'b33cb427-0619-479b-81bc-8c66eb5caff1';
      final postId = 'd11ab56e-f1d0-4d13-bfe0-788a3fddcebf';

      expect(layer.match('/users/$userId/posts/$postId', method), isTrue);
      expect(layer.parameters, equals(['userId', 'postId']));
      expect(
          layer.routeParams,
          equals({
            'userId': userId,
            'postId': postId,
          }));

      expect(layer.match('/users/1', method), isFalse);
    });
  });

  group('route handling', () {
    test('calls the handler method with the expected values', () {
      var called = false;

      void mockHandler(Request request, Response res) {
        called = true;
      }

      layer = Layer('/', handle: mockHandler);

      var req = Request(null);
      var res = Response(null, null);

      layer.handleRequest(req, res);

      expect(called, isTrue);
    });
  });
}
