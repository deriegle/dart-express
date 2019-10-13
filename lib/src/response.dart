import 'package:dart_express/src/app.dart';
import 'dart:convert' as convert;
import 'dart:io';

class Response {
  HttpResponse response;
  App app;

  Response(this.response, this.app);

  Response send(dynamic body) {
    if (body is Map) {
      this.json(body);
    } else if (body is String) {
      if (headers.contentType == null) {
        this.headers.add('Content-Type', 'text/plain');
      }

      this.encoding = convert.Encoding.getByName('utf-8');
      this.write(body);
      this.close();
    }

    return this;
  }

  render(String viewName, [Map<String, dynamic> locals]) {
    this.app.render(viewName, locals, (err, data) {
      if (err != null) {
        print(err);

        this.response.close();
        return;
      }

      this.html(data);
    });
  }

  Response html(String html) {
    this.headers.contentType = ContentType.html;
    this.send(html);
    return this;
  }

  Response json(Map<String, dynamic> body) {
    this.headers.contentType = ContentType.json;

    return this.send(convert.json.encode(body));
  }

  Response set(String headerName, dynamic headerContent) {
    this.headers.add(headerName, headerContent);
    return this;
  }

  Response status(int code) {
    this.statusCode = code;
    return this;
  }

  convert.Encoding encoding;

  void add(List<int> data) {
    return this.response.add(data);
  }

  void addError(Object error, [StackTrace stackTrace]) {
    return this.response.addError(error, stackTrace);
  }

  get statusCode => this.response.statusCode;
  set statusCode(int newCode) => this.response.statusCode = newCode;

  Future addStream(Stream<List<int>> stream) {
    return this.response.addStream(stream);
  }

  Future close() {
    return this.response.close();
  }

  HttpConnectionInfo get connectionInfo => this.response.connectionInfo;

  List<Cookie> get cookies => this.response.cookies;

  Future<Socket> detachSocket({bool writeHeaders = true}) {
    return this.response.detachSocket(writeHeaders: writeHeaders);
  }

  Future get done => this.response.done;

  Future flush() {
    return this.response.flush();
  }

  HttpHeaders get headers => this.response.headers;

  Future redirect(String location, { int status = HttpStatus.movedTemporarily }) {
    return this.response.redirect(Uri.tryParse(location), status: status);
  }

  void write(Object obj) {
    return this.response.write(obj);
  }

  void writeAll(Iterable objects, [String separator = ""]) {
    return this.response.writeAll(objects, separator);
  }

  void writeCharCode(int charCode) {
    return this.response.writeCharCode(charCode);
  }

  void writeln([Object obj = ""]) {
    return this.response.writeln(obj);
  }

  end() => this.close();

  location(String path) {
    this.headers.add('Location', path);
  }
}
