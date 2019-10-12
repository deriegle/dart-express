import 'dart:io';
import 'package:dart_express/dart_express.dart';

const int PORT = 5000;

main() {
  var app = express();

  app.use(BodyParser.json());

  app.get('/', (req, res, _)  {
    res.statusCode = HttpStatus.ok;

    res.json({
      'hello': 'world',
      'age': 25,
    });
  });

  app.all('/secret', (req, res, next) {
    print('Accessing the secret section');

    next();
  });

  app.get('/secret', (Request req, Response res, next) {
    res.send('Secret Home Page');
  });

  app.get('/2', (req, res, _) {
    res.html('<h1>Hello, world</h1><p>Hi there. I am testing the sending of HTML from my dart express server</p><h2>Here is the second heading</h2>');
  });

  app.post('/post',(Request req, Response res, _) async {
    print(req.body);

    res.send('Data from post :)');
  });

  app.listen(PORT, (int port) => print('Listening on port $port'));
}


// curl "http://localhost:5000/post" -H "Content-Type: application/json" -d '{"name": "Devin Riegle"}'