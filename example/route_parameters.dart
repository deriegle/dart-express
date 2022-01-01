import 'package:dart_express/dart_express.dart';

main() {
  final app = express();

  app.get('/users/:userId/posts/:postId', (req, res) {
    res.json({
      'userId': req.params['userId'],
      'postId': req.params['postId'],
    });
  });

  app.listen(
    port: 3000,
    cb: (port) => print('Listening on port $port'),
  );
}
