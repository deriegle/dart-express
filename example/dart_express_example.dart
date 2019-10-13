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
    res.render('index');
  });

  app.get('/3', (req, res, _) {
    res.render('about', {
      'first_name': req.params['first_name'] ?? 'Devin Riegle',
      'person': req.params['person']
    });
  });

  app.post('/post',(Request req, Response res, _) async {
    print(req.body);

    res.send('Data from post :)');
  });

  app.listen(PORT, (int port) => print('Listening on port $port'));
}

// curl "http://localhost:5000/post" -H "Content-Type: application/json" -d '{"name": "Devin Riegle"}'