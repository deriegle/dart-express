An express-like web server framework for Dart developers.

Created from templates made available by Stagehand under a BSD-style
[license](https://github.com/dart-lang/stagehand/blob/master/LICENSE).

## Usage

A simple usage example:

```dart
import 'package:dart_express/dart_express.dart';

main() {
  var app = express();

  app.get('/', (req, res, _) {
    res.json({
      'hello': 'world',
      'test': true,
    });
  });

  app.listen(3000, (port) => print('Listening on port $port');
}
```

With Body parsing Middleware:

```dart
import 'package:dart_express/dart_express.dart';

main() {
  var app = express();

  app.use(BodyParser.json());

  app.post('/post', (req, res, _) {
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
  var app = express();

  app.use(BodyParser.json());
  app.engine(MustacheEngine.use());

  app.settings.viewsPath = 'custom_views_path';
  app.settings.viewEngine = 'mustache';

  app.get('/', (req, res, _) {
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
- [X] Basic Routing
- [X] Easily build Middleware
- [X] Add & use view engines easily
- [] Add in-depth testing
- [] Add support for routes with params like express supports. example: "/posts/:postId"
- [] Clean up imports and extract middleware to separate packages
- [] Add Dart "morgan" middleware package for logging HTTP requests
- [] Add CORS middleware package
