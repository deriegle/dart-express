import 'package:dart_express/src/view.dart';

class ViewException implements Error {
  final View view;
  final String directory;

  ViewException(this.view, this.directory);

  String get message =>
      'ViewException(Failed to find ${view.filePath}${view.ext} in ${directory})';

  @override
  StackTrace get stackTrace => StackTrace.fromString('ViewException');
}
