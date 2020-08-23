part of dart_express;

class Response {
  HttpResponse response;
  App app;

  Response(this.response, this.app);

  Response send(dynamic body) {
    if (body is Map) {
      json(body);
    } else if (body is String) {
      if (headers.contentType == null) {
        headers.add('Content-Type', 'text/plain');
      }

      encoding = convert.Encoding.getByName('utf-8');
      write(body);
      close();
    }

    return this;
  }

  void render(String viewName, [Map<String, dynamic> locals]) {
    app.render(viewName, locals, (err, data) {
      if (err != null) {
        print(err);

        response.close();
        return;
      }

      html(data);
    });
  }

  Response html(String html) {
    headers.contentType = ContentType.html;
    send(html);
    return this;
  }

  Response json(Map<String, dynamic> body) {
    headers.contentType = ContentType.json;
    return send(convert.json.encode(body));
  }

  Response set(String headerName, dynamic headerContent) {
    headers.add(headerName, headerContent);
    return this;
  }

  Response status(int code) {
    statusCode = code;
    return this;
  }

  convert.Encoding encoding;

  int get statusCode => response.statusCode;
  set statusCode(int newCode) => response.statusCode = newCode;

  Future close() => response.close();

  HttpConnectionInfo get connectionInfo => response.connectionInfo;

  List<Cookie> get cookies => response.cookies;

  Future<bool> get isDone async =>
      response.done.then((d) => true).catchError((e) => false);

  Future flush() => response.flush();

  HttpHeaders get headers => response.headers;

  Future redirect(
    String location, {
    int status = HttpStatus.movedTemporarily,
  }) =>
      response.redirect(Uri.tryParse(location), status: status);

  void write(Object obj) => response.write(obj);
  void location(String path) => headers.add('Location', path);

  Future end() => close();
}
