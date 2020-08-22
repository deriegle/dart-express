import 'package:dart_express/src/app.dart';
import 'dart:convert' as convert;
import 'dart:io';

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

  void add(List<int> data) {
    return response.add(data);
  }

  void addError(Object error, [StackTrace stackTrace]) {
    return response.addError(error, stackTrace);
  }

  int get statusCode => response.statusCode;
  set statusCode(int newCode) => response.statusCode = newCode;

  Future addStream(Stream<List<int>> stream) {
    return response.addStream(stream);
  }

  Future close() {
    return response.close();
  }

  HttpConnectionInfo get connectionInfo => response.connectionInfo;

  List<Cookie> get cookies => response.cookies;

  Future<Socket> detachSocket({writeHeaders = true}) =>
      response.detachSocket(writeHeaders: writeHeaders);

  Future get done => response.done;

  Future flush() {
    return response.flush();
  }

  HttpHeaders get headers => response.headers;

  Future redirect(String location, {int status = HttpStatus.movedTemporarily}) {
    return response.redirect(Uri.tryParse(location), status: status);
  }

  void write(Object obj) => response.write(obj);

  void writeAll(Iterable objects, [String separator = '']) =>
      response.writeAll(objects, separator);

  void writeCharCode(int charCode) => response.writeCharCode(charCode);

  void writeln([Object obj = '']) => response.writeln(obj);

  Future end() => close();

  void location(String path) {
    headers.add('Location', path);
  }
}
