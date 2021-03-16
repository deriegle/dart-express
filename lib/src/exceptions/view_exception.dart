part of dart_express;

class _ViewException implements Error {
  final _View view;
  final String directory;

  _ViewException(this.view, this.directory);

  String get message =>
      'ViewException(Failed to find ${view.name}${view.ext} in $directory)';

  @override
  String toString() => message;

  @override
  StackTrace get stackTrace => StackTrace.fromString('ViewException');
}
