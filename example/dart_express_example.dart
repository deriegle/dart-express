import 'package:dart_express/dart_express.dart';

main() {
  var app = express();

  app.get('/', (req, res, cb) {
    res.statusCode = 200;
    res.write('Hello, world');
    res.close();
  });

  app.listen(3000, (port) => print('Listening on port $port'));
}
