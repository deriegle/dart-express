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

  router.get('/jael', (req, res) {
    res.render(
      'test.jael',
      {'template_engine': 'Jael', 'first_name': 'Thosakwe'},
    );
  });

  router.get('/users/:userId/posts/:postId', (req, res) {
    print(req.params);

    res.render(
      'test.jael',
      {'template_engine': req.params['postId'], 'first_name': 'George'},
    );
  });

  return router;
}
