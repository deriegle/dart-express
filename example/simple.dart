import 'package:dart_express/dart_express.dart';

main() {
  final app = express();

  app.get('/', (req, res) {
    res.json({
      'hello': 'world',
      'test': true,
    });
  });

  app.listen(
    port: 3000,
    cb: (port) => print('Listening on port $port'),
  );
}
