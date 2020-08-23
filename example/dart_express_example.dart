import 'package:dart_express/dart_express.dart';
import 'package:path/path.dart' as path;
import './api_routes.dart';
import './view_routes.dart';

const int PORT = 5000;

void main() {
  final app = express();

  app.use(BodyParser.json());
  app.use(CorsMiddleware.use());
  app.use(LoggerMiddleware.use(includeImmediate: true));

  app.engine(MarkdownEngine.use());
  app.engine(MustacheEngine.use());
  app.engine(JaelEngine.use());

  app.set('print routes', true);
  app.set('views', path.join(path.current, 'example/views'));
  app.set('view engine', 'mustache');

  app.useRouter('/api/', apiRouter());
  app.useRouter('/', viewRouter());

  app.listen(port: PORT, cb: (int port) => print('Listening on port $port'));
}
