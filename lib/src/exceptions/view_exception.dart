part of dart_express;

class _ViewException implements Error {
  final String name;
  final String ext;
  final String directory;

  _ViewException(this.name, this.ext, this.directory);

  String get message => 'ViewException(Failed to find $name$ext in $directory)';

  @override
  String toString() => message;

  @override
  StackTrace get stackTrace => StackTrace.fromString('ViewException');
}
