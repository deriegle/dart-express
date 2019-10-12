import 'dart:convert' as convert;
import 'dart:io';

class Response extends HttpResponse {
  HttpResponse response;

  Response(this.response);

  Response send(dynamic body) {
    if (body is Map) {
      this.json(body);
    } else if (body is String) {
      this.headers.add('Content-Type', 'text/plain');
      this.encoding = convert.Encoding.getByName('utf-8');
      this.write(body);
      this.close();
    }

    return this;
  }

  Response json(Map<String, dynamic> body) {
    this.headers.add('Content-Type', 'application/json');

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

  @override
  convert.Encoding encoding;

  @override
  void add(List<int> data) {
    return this.response.add(data);
  }

  @override
  void addError(Object error, [StackTrace stackTrace]) {
    return this.response.addError(error, stackTrace);
  }

  get statusCode => this.response.statusCode;
  set statusCode(int newCode) => this.response.statusCode = newCode;

  @override
  Future addStream(Stream<List<int>> stream) {
    return this.response.addStream(stream);
  }

  @override
  Future close() {
    return this.response.close();
  }

  @override
  HttpConnectionInfo get connectionInfo => this.response.connectionInfo;

  @override
  List<Cookie> get cookies => this.response.cookies;

  @override
  Future<Socket> detachSocket({bool writeHeaders = true}) {
    return this.response.detachSocket(writeHeaders: writeHeaders);
  }

  @override
  Future get done => this.response.done;

  @override
  Future flush() {
    return this.response.flush();
  }

  @override
  HttpHeaders get headers => this.response.headers;

  @override
  Future redirect(Uri location, {int status = HttpStatus.movedTemporarily}) {
    return this.response.redirect(location, status: status);
  }

  @override
  void write(Object obj) {
    return this.response.write(obj);
  }

  @override
  void writeAll(Iterable objects, [String separator = ""]) {
    return this.response.writeAll(objects, separator);
  }

  @override
  void writeCharCode(int charCode) {
    return this.response.writeCharCode(charCode);
  }

  @override
  void writeln([Object obj = ""]) {
    return this.response.writeln(obj);
  }
}