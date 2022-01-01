import 'package:dart_express/dart_express.dart';

Router viewRouter() {
  final router = Router();

  router.get('/example', (req, res) {
    res.render('example.md');
  });

  router.all('/secret', (req, res) {
    print('Accessing the secret section');
    req.next();
  });

  router.get('/secret', (req, res) {
    res.send('Secret Home Page');
  });

  router.get('/secret/2', (req, res) {
    res.send('Secret Home Page');
  });

  return router;
}
