part of dart_express;

class Request {
  final HttpRequest _request;
  Next next;
  Map<String, dynamic> body;
  Map<String, dynamic> params;

  Request(this._request) {
    body = <String, dynamic>{};

    if (request != null) {
      params = Map.from(request.requestedUri.queryParameters);
    }
  }

  HttpRequest get request => _request;

  X509Certificate get certificate => request.certificate;

  HttpConnectionInfo get connectionInfo => request.connectionInfo;

  int get contentLength => request.contentLength;

  List<Cookie> get cookies => request.cookies;

  HttpHeaders get headers => request.headers;

  Future<bool> get isEmpty => request.isEmpty;

  Future<int> get length => request.length;

  String get method => request.method;

  Uri get requestedUri => request.requestedUri;

  HttpResponse get response => request.response;

  HttpSession get session => request.session;

  Uri get uri => request.uri;
}
