import "package:path/path.dart" as path;
import 'package:dart_express/src/app.dart';
import 'package:mustache4dart/mustache4dart.dart' as mustache;
import 'dart:convert' as convert;
import 'dart:io';

class Response extends HttpResponse {
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

  render(String viewName, [Map<String, dynamic> locals, Function callback]) {
    this.app.render(viewName, locals, callback);
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

  String _pathForRenderTemplate(String templateName) {
    String extensionName = path.extension(templateName);

    if (extensionName.isEmpty) { extensionName = 'html'; }

    return path.join(path.dirname(Platform.script.path), 'views/$templateName.$extensionName');
  }

}

/*
  res.render = function render(view, options, callback) {
  var app = this.req.app;
  var done = callback;
  var opts = options || {};
  var req = this.req;
  var self = this;

  // support callback function as second arg
  if (typeof options === 'function') {
    done = options;
    opts = {};
  }

  // merge res.locals
  opts._locals = self.locals;

  // default callback to respond
  done = done || function (err, str) {
    if (err) return req.next(err);
    self.send(str);
  };

  // render
  app.render(view, opts, done);
};
*/