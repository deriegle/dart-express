import 'dart:io';

import 'package:dart_express/dart_express.dart';

main() {
  final app = express();

  app.get('/', (req, res) {
    res.json({
      'hello': 'world',
      'test': true,
    });
  });

  final chain = Platform.script.resolve('certificates/chain.pem').toFilePath();
  final key = Platform.script.resolve('certificates/key.pem').toFilePath();
  final context = SecurityContext()
    ..useCertificateChain(chain)
    ..usePrivateKey(key);

  app.listen(
    port: 80,
    cb: (port) => print('listening for http on port $port'),
  );

  //listen for https requests
  app.listenHttps(
    context,
    port: 443,
    cb: (port) => print('Listening for https on port $port'),
  );
}
