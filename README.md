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



Listening to Https requests

```dart
  //listen for http requests
  app.listen(port: 80, cb: (port) => print('listening for http on port $port'));

  //assign certificate
  var context = SecurityContext();
  final chain = Platform.script.resolve('certificates/chain.pem').toFilePath();
  final key = Platform.script.resolve('certificates/key.pem').toFilePath();

  context.useCertificateChain(chain);
  context.usePrivateKey(key);

  //listen for https requests
  app.listenHttps(
    context,
    port: 443,
    cb: (port) => print('Listening for https on port $port'),
  );
```



### Currently supported View Engines

- Basic HTML
- Mustache
- Markdown
- Jael
