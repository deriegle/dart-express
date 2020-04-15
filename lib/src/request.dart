import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dart_express/src/route.dart';

class Request extends HttpRequest {
  HttpRequest request;
  Next _next;
  Map<String, dynamic> _body;
  Map<String, dynamic> params;

  Request(this.request) {
    this._next = () {};

    if (this.request != null) {
      this.params = Map.from(request.requestedUri.queryParameters);
    }
  }

  get body => this._body;
  set body(newBody) => this._body = newBody;
  set next(Next next) => this._next = next;
  get next => this._next;

  @override
  any(test) => this.request.any(test);

  @override
  Stream<Uint8List> asBroadcastStream({onListen, onCancel}) =>
      this.request.asBroadcastStream(onCancel: onCancel, onListen: onListen);

  @override
  Stream<E> asyncExpand<E>(convert) => this.request.asyncExpand<E>(convert);

  @override
  Stream<E> asyncMap<E>(convert) => this.request.asyncMap(convert);

  @override
  Stream<R> cast<R>() => this.request.cast<R>();

  @override
  X509Certificate get certificate => this.request.certificate;

  @override
  HttpConnectionInfo get connectionInfo => this.request.connectionInfo;

  @override
  Future<bool> contains(Object needle) => this.request.contains(needle);

  @override
  int get contentLength => this.request.contentLength;

  @override
  List<Cookie> get cookies => this.request.cookies;

  @override
  distinct([equals]) => this.request.distinct(equals);

  @override
  Future<E> drain<E>([E futureValue]) {
    return this.request.drain(futureValue);
  }

  @override
  Future<Uint8List> elementAt(int index) {
    return this.request.elementAt(index);
  }

  @override
  every(test) => this.request.every(test);

  @override
  expand<S>(convert) => this.request.expand<S>(convert);

  @override
  Future<Uint8List> get first => this.request.first;

  @override
  firstWhere(test, {orElse}) => this.request.firstWhere(test, orElse: orElse);

  @override
  fold<S>(initialValue, combine) => this.request.fold<S>(initialValue, combine);

  @override
  Future forEach(void Function(Uint8List element) action) =>
      this.request.forEach(action);

  @override
  handleError(onError, {test}) => this.request.handleError(onError, test: test);

  @override
  HttpHeaders get headers => this.request.headers;

  @override
  bool get isBroadcast => this.request.isBroadcast;

  @override
  Future<bool> get isEmpty => this.request.isEmpty;

  @override
  join([String separator = ""]) => this.request.join(separator);

  @override
  get last => this.request.last;

  @override
  lastWhere(test, {orElse}) => this.request.lastWhere(test, orElse: orElse);

  @override
  Future<int> get length => this.request.length;

  @override
  listen(onData, {onError, onDone, cancelOnError}) =>
      this.request.listen(onData,
          cancelOnError: cancelOnError, onDone: onDone, onError: onError);

  @override
  map<S>(convert) => this.request.map<S>(convert);

  @override
  String get method => this.request.method;

  @override
  bool get persistentConnection => this.request.persistentConnection;

  @override
  pipe(streamConsumer) => this.request.pipe(streamConsumer);

  @override
  String get protocolVersion => this.request.protocolVersion;

  @override
  reduce(combine) => this.request.reduce(combine);

  @override
  Uri get requestedUri => this.request.requestedUri;

  @override
  HttpResponse get response => this.request.response;

  @override
  HttpSession get session => this.request.session;

  @override
  Future<Uint8List> get single => this.request.single;

  @override
  singleWhere(test, {orElse}) => this.request.singleWhere(test, orElse: orElse);

  @override
  skip(count) => this.request.skip(count);

  @override
  skipWhile(test) => this.request.skipWhile(test);

  @override
  take(int count) => this.request.take(count);

  @override
  takeWhile(test) => this.request.takeWhile(test);

  @override
  timeout(timeLimit, {onTimeout}) =>
      this.request.timeout(timeLimit, onTimeout: onTimeout);

  @override
  toList() => this.request.toList();

  @override
  toSet() => this.request.toSet();

  @override
  transform<S>(streamTransformer) =>
      this.request.transform<S>(streamTransformer);

  @override
  Uri get uri => this.request.uri;

  @override
  where(test) => this.request.where(test);
}
