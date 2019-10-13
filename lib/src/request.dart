import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

class Request extends HttpRequest {
  HttpRequest request;
  Map<String, dynamic> _body;

  Request(this.request);

  Map<String, String> get params => request.requestedUri.queryParameters;

  get body => this._body;
  set body(newBody) => this._body = newBody;

  @override
  Future<bool> any(bool Function(Uint8List element) test) {
    return this.request.any(test);
  }

  @override
  Stream<Uint8List> asBroadcastStream(
      {void Function(StreamSubscription<Uint8List> subscription) onListen,
      void Function(StreamSubscription<Uint8List> subscription) onCancel}) {
    return this
        .request
        .asBroadcastStream(onCancel: onCancel, onListen: onListen);
  }

  @override
  Stream<E> asyncExpand<E>(Stream<E> Function(Uint8List event) convert) {
    return this.request.asyncExpand(convert);
  }

  @override
  Stream<E> asyncMap<E>(FutureOr<E> Function(Uint8List event) convert) {
    return this.request.asyncMap(convert);
  }

  @override
  Stream<R> cast<R>() {
    return this.request.cast<R>();
  }

  @override
  X509Certificate get certificate => this.request.certificate;

  @override
  HttpConnectionInfo get connectionInfo => this.request.connectionInfo;

  @override
  Future<bool> contains(Object needle) {
    return this.request.contains(needle);
  }

  @override
  int get contentLength => this.request.contentLength;

  @override
  List<Cookie> get cookies => this.request.cookies;

  @override
  Stream<Uint8List> distinct(
      [bool Function(Uint8List previous, Uint8List next) equals]) {
    return this.request.distinct(equals);
  }

  @override
  Future<E> drain<E>([E futureValue]) {
    return this.request.drain(futureValue);
  }

  @override
  Future<Uint8List> elementAt(int index) {
    return this.request.elementAt(index);
  }

  @override
  Future<bool> every(bool Function(Uint8List element) test) {
    return this.request.every(test);
  }

  @override
  Stream<S> expand<S>(Iterable<S> Function(Uint8List element) convert) {
    return this.request.expand(convert);
  }

  @override
  Future<Uint8List> get first => this.request.first;

  @override
  Future<Uint8List> firstWhere(bool Function(Uint8List element) test,
      {Uint8List Function() orElse}) {
    return this.request.firstWhere(test, orElse: orElse);
  }

  @override
  Future<S> fold<S>(
      S initialValue, S Function(S previous, Uint8List element) combine) {
    return this.request.fold(initialValue, combine);
  }

  @override
  Future forEach(void Function(Uint8List element) action) {
    return this.request.forEach(action);
  }

  @override
  Stream<Uint8List> handleError(Function onError,
      {bool Function(dynamic) test}) {
    return this.request.handleError(onError, test: test);
  }

  @override
  HttpHeaders get headers => this.request.headers;

  @override
  bool get isBroadcast => this.request.isBroadcast;

  @override
  Future<bool> get isEmpty => this.request.isEmpty;

  @override
  Future<String> join([String separator = ""]) {
    return this.request.join(separator);
  }

  @override
  Future<Uint8List> get last => this.request.last;

  @override
  Future<Uint8List> lastWhere(bool Function(Uint8List element) test,
      {Uint8List Function() orElse}) {
    return this.request.lastWhere(test, orElse: orElse);
  }

  @override
  Future<int> get length => this.request.length;

  @override
  StreamSubscription<Uint8List> listen(void Function(Uint8List event) onData,
      {Function onError, void Function() onDone, bool cancelOnError}) {
    return this.request.listen(onData,
        cancelOnError: cancelOnError, onDone: onDone, onError: onError);
  }

  @override
  Stream<S> map<S>(S Function(Uint8List event) convert) {
    return this.request.map(convert);
  }

  @override
  String get method => this.request.method;

  @override
  bool get persistentConnection => this.request.persistentConnection;

  @override
  Future pipe(StreamConsumer<Uint8List> streamConsumer) {
    return this.request.pipe(streamConsumer);
  }

  @override
  String get protocolVersion => this.request.protocolVersion;

  @override
  Future<Uint8List> reduce(
      Uint8List Function(Uint8List previous, Uint8List element) combine) {
    return this.request.reduce(combine);
  }

  @override
  Uri get requestedUri => this.request.requestedUri;

  @override
  HttpResponse get response => this.request.response;

  @override
  HttpSession get session => this.request.session;

  @override
  Future<Uint8List> get single => this.request.single;

  @override
  Future<Uint8List> singleWhere(bool Function(Uint8List element) test,
      {Uint8List Function() orElse}) {
    return this.request.singleWhere(test, orElse: orElse);
  }

  @override
  Stream<Uint8List> skip(int count) {
    return this.request.skip(count);
  }

  @override
  Stream<Uint8List> skipWhile(bool Function(Uint8List element) test) {
    return this.request.skipWhile(test);
  }

  @override
  Stream<Uint8List> take(int count) {
    return this.request.take(count);
  }

  @override
  Stream<Uint8List> takeWhile(bool Function(Uint8List element) test) {
    return this.request.takeWhile(test);
  }

  @override
  Stream<Uint8List> timeout(Duration timeLimit,
      {void Function(EventSink<Uint8List> sink) onTimeout}) {
    return this.request.timeout(timeLimit, onTimeout: onTimeout);
  }

  @override
  Future<List<Uint8List>> toList() {
    return this.request.toList();
  }

  @override
  Future<Set<Uint8List>> toSet() {
    return this.request.toSet();
  }

  @override
  Stream<S> transform<S>(StreamTransformer<Uint8List, S> streamTransformer) {
    return this.request.transform(streamTransformer);
  }

  @override
  Uri get uri => this.request.uri;

  @override
  Stream<Uint8List> where(bool Function(Uint8List event) test) {
    return this.request.where(test);
  }
}
