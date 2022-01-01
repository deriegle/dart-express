part of dart_express;

class _HTTPMethods {
  static const get = 'GET';
  static const post = 'POST';
  static const delete = 'DELETE';
  static const head = 'HEAD';
  static const patch = 'PATCH';
  static const put = 'PUT';
  static const options = 'OPTIONS';

  static const all = [
    get,
    post,
    delete,
    head,
    patch,
    put,
    options,
  ];
}
