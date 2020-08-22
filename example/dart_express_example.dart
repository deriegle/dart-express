import 'package:dart_express/dart_express.dart';

const int PORT = 5000;

main() {
  var app = express();

  app.use(BodyParser.json());
  app.engine(MarkdownEngine.use());
  app.engine(MustacheEngine.use());
  app.engine(JaelEngine.use());
  app.set('views', 'views');

  app.get('/', (req, res) {
    res.statusCode = HttpStatus.ok;

    res.json({
      'hello': 'world',
      'age': 25,
    });
  });

  app.get('/example', (req, res) {
    res.render('example.md');
  });

  app.all('/secret', (req, res) {
    print('Accessing the secret section');

    req.next();
  });

  app.get('/secret', (req, res) {
    res.send('Secret Home Page');
  });

  app.get('/secret/2', (req, res) {
    res.send('Secret home page 2');
  });

  app.get('/2', (req, res) {
    res.render('index');
  });

  app.get('/3', (req, res) {
    res.render('about',
        {'first_name': req.params['first_name'] ?? 'Devin Riegle', 'person': req.params['person']});
  });

  app.get('/4', (req, res) {
    res.render(
      'test.jael',
      {'template_engine': 'Jael', 'first_name': 'Thosakwe'},
    );
  });

  app.post('/post', (req, res) {
    res.send('Data from post :)');
  });

  app.get('/users/:userId/posts/:postId', (req, res) {
    print(req.params);

    res.render(
      'test.jael',
      {'template_engine': req.params['postId'], 'first_name': 'George'},
    );
  });

  app.listen(port: PORT, cb: (int port) => print('Listening on port $port'));
}
