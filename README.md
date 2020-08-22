# Dart Express ![Dart CI](https://github.com/deriegle/dart-express/workflows/Dart%20CI/badge.svg?branch=master)
An express-like web server framework for Dart developers.

## Usage

A simple usage example:

```dart
import 'package:dart_express/dart_express.dart';

main() {
  final app = express();

  app.get('/', (req, res) {
    res.json({
      'hello': 'world',
      'test': true,
    });
  });

  app.listen(3000, (port) => print('Listening on port $port');
}
```

Example with route parameters

```dart
import 'package:dart_express/dart_express.dart';

main() {
  final app = express();

  app.get('/users/:userId/posts/:postId', (req, res) {
    res.json({
      'userId': req.params['userId'],
      'postId': req.params['postId'],
    });
  });

  app.listen(3000, (port) => print('Listening on port $port');
}
```

With Body parsing Middleware:

```dart
import 'package:dart_express/dart_express.dart';

main() {
  final app = express();

  app.use(BodyParser.json());

  app.post('/post', (req, res) {
    print(req.body);

    res.send({
      'request_body': req.body,
    });
  });

  app.listen(3000, (port) => print('Listening on port $port');
}
```

Using the mustache templating engine

```dart
import 'package:dart_express/dart_express.dart';

main() {
  final app = express();

  app.use(BodyParser.json());
  app.engine(MustacheEngine.use());
  
  app.settings
    ..viewsPath = 'custom_views_path'
    ..viewEngine = 'mustache';

  app.get('/', (req, res) {
    res.render('index', {
      'app_name': 'My Test App',
    });
  });

  app.listen(3000, (port) => print('Listening on port $port');
}
```

### Currently supported View Engines

- Basic HTML
- Mustache
- Jael

### Roadmap

- [ ] Clean up imports and extract middleware to separate packages
- [ ] Add Dart "morgan" middleware package for logging HTTP requests
- [ ] Add CORS middleware package
