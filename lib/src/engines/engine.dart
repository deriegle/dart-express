part of dart_express;

typedef HandlerCallback = Function(dynamic e, String? rendered);
typedef Handler = Function(
    String filePath, Map<String, dynamic>? locals, HandlerCallback cb);

class Engine {
  final String ext;
  final Handler handler;

  const Engine(this.ext, this.handler);
}
