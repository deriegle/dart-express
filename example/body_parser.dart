import 'package:dart_express/dart_express.dart';

main() {
  final app = express();

  app.use(BodyParser.json());

  app.post('/post', (req, res) {
    res.send({
      'body': req.body,
    });
  });

  app.listen(
    port: 3000,
    cb: (port) => print('Listening on port $port'),
  );
}
