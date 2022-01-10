import 'package:collection/collection.dart' show IterableExtension;
import 'package:dart_express/dart_express.dart';

const int port = 5000;

class User {
  final int id;
  final String? email;

  User({
    required this.id,
    required this.email,
  });

  User copyWith({String? email}) {
    return User(id: id, email: email ?? this.email);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
    };
  }
}

Router apiRouter() {
  final router = Router();
  final users = [
    User(id: 1, email: 'test@example.com'),
    User(id: 2, email: 'test2@example.com'),
  ];

  router.get('/users', (req, res) {
    res.status(200).json({
      'users': users.map((u) => u.toJson()).toList(),
    });
  });

  router.post('/users', (req, res) {
    final int? id = req.body['id'];
    final String? email = req.body['email']?.trim();
    final Map<String, List<String>> errors = {};

    if (id == null) {
      final errorMessage = 'ID is required';

      if (errors.containsKey('id')) {
        errors['id']!.add(errorMessage);
      } else {
        errors['id'] = [errorMessage];
      }
    }

    if (users.firstWhereOrNull((u) => u.id == id) != null) {
      final errorMessage = 'ID must be unique.';

      if (errors.containsKey('id')) {
        errors['id']!.add(errorMessage);
      } else {
        errors['id'] = [errorMessage];
      }
    }

    if (email == null || email.isEmpty) {
      final errorMessage = 'Email is required';

      if (errors.containsKey('email')) {
        errors['email']!.add(errorMessage);
      } else {
        errors['email'] = [errorMessage];
      }
    }

    if (email != null && !email.contains('@')) {
      final errorMessage = 'Email is not valid.';

      if (errors.containsKey('email')) {
        errors['email']!.add(errorMessage);
      } else {
        errors['email'] = [errorMessage];
      }
    }

    if (errors.keys.isNotEmpty) {
      final List<Map<String, String>> errorJson = [];

      for (final key in errors.keys) {
        for (final errorMessage in errors[key]!) {
          errorJson.add({'key': key, 'message': errorMessage});
        }
      }

      return res.json({
        'errors': errorJson,
      });
    }

    final user = User(id: id!, email: email!);

    users.add(user);

    res.status(201).json({
      'user': user.toJson(),
    });
  });

  router.get('/users/:userId', (req, res) {
    final String userId = req.params['userId'];
    final id = int.tryParse(userId);

    if (id == null) {
      return res.status(404).end();
    }

    final user = users.firstWhereOrNull((element) => element.id == id);

    if (user == null) {
      return res.status(404).end();
    }

    return res.json({
      'user': user.toJson(),
    });
  });

  router.post('/users/:userId', (req, res) {
    final String userId = req.params['userId'];
    final id = int.tryParse(userId);
    final email = req.body['email'];
    final Map<String, List<String>> errors = {};

    if (email == null || email.isEmpty) {
      final errorMessage = 'Email is required';

      if (errors.containsKey('email')) {
        errors['email']!.add(errorMessage);
      } else {
        errors['email'] = [errorMessage];
      }
    }

    if (email != null && !email.contains('@')) {
      final errorMessage = 'Email is not valid.';

      if (errors.containsKey('email')) {
        errors['email']!.add(errorMessage);
      } else {
        errors['email'] = [errorMessage];
      }
    }

    if (errors.keys.isNotEmpty) {
      final List<Map<String, String>> errorJson = [];

      for (final key in errors.keys) {
        for (final errorMessage in errors[key]!) {
          errorJson.add({'key': key, 'message': errorMessage});
        }
      }

      return res.json({
        'errors': errorJson,
      });
    }

    final user = users.firstWhereOrNull((element) => element.id == id);

    if (user == null) {
      return res.status(404).end();
    }

    final index = users.indexWhere((element) => element.id == id);
    users[index] = user.copyWith(email: email);

    return res.json({
      'user': user.toJson(),
    });
  });

  router.delete('/users/:userId', (req, res) {
    final String userId = req.params['userId'];
    final id = int.tryParse(userId);
    final user = users.firstWhereOrNull((element) => element.id == id);

    if (user == null) {
      return res.status(404).end();
    }

    users.remove(user);

    return res.status(200).end();
  });

  return router;
}

void main() {
  final app = express();

  app.use(BodyParser.json());
  app.use(CorsMiddleware.use());
  app.use(LoggerMiddleware.use(includeImmediate: true));

  app.useRouter('/api/', apiRouter());

  app.listen(
    port: port,
    cb: (int port) => print('Listening on port $port'),
  );
}
