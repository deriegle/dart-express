import 'package:dart_express/dart_express.dart';
import 'package:meta/meta.dart';

class User {
  final int id;
  final String email;

  User({@required this.id, @required this.email});

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

  router.get('/', (req, res) {
    res.status(200).json({
      'hello': 'world',
      'age': 25,
    });
  });

  router.get('/users', (req, res) {
    res.status(200).json({
      'users': users.map((u) => u.toJson()).toList(),
    });
  });

  router.post('/users', (req, res) {
    final int id = req.body['id'];
    final String email = req.body['email']?.trim();

    if (id == null) {
      res.status(400).json({
        'errors': [
          {'key': 'id', 'message': 'ID is required'}
        ]
      });
      return;
    }

    if (users.firstWhere((u) => u.id == id, orElse: () => null) != null) {
      res.status(400).json({
        'errors': [
          {'key': 'id', 'message': 'ID must be unique'}
        ]
      });
      return;
    }

    if (email == null || email.isEmpty) {
      res.status(400).json({
        'errors': [
          {'key': 'email', 'message': 'Email is required'}
        ]
      });
      return;
    }

    final user = User(
      id: req.body['id'],
      email: req.body['email'],
    );

    users.add(user);

    res.status(201).json({
      'user': user.toJson(),
    });
  });

  return router;
}
