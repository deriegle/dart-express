import 'package:dart_express/dart_express.dart';

main() {
  var app = express();

  app.get('/', (req, res, next) {
    print('next');

    next();
  });

  app.get('/', (req, res, _)  {
    res.statusCode = 200;
    res.write('Hello, world');
    res.close();
  });

  app.get('/2', (req, res, _) {
    res.statusCode = 200;
    res.write('Hello world from /2');
    res.close();
  });

  app.post('/post',(req, res, _) {
    res.statusCode = 200;
    res.write('Data from post :)');
    res.close();
  });

  app.listen(3000, (port) => print('Listening on port $port'));
}
