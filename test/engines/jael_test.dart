import 'dart:io';

import 'package:dart_express/dart_express.dart';
import 'package:jael/jael.dart' as jael;
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

class MockFileRepository extends Mock implements FileRepository {}

final mockJael = '''
<html>
<head>
  <title>Mock Jael Title</title>
</head>
<body>
  <h1>Hello, world</h1>
</body>
</html>
''';

void main() {
  test('JaelEngine has the correct extension', () {
    expect(JaelEngine.ext, '.jael');
  });

  test('JaelEngine handles reading a file correctly', () async {
    final filePath = './views/index.jael';
    var error;
    var rendered;

    HandlerCallback callback = (err, string) {
      error = err;
      rendered = string;
    };

    final mockFileRepository = MockFileRepository();

    when(mockFileRepository.readAsString(Uri.file(filePath)))
        .thenAnswer((_) async => mockJael);

    await JaelEngine.handler(filePath, {}, callback, mockFileRepository);

    expect(error, null);
    expect(rendered, contains('<html>'));
  });

  test('JaelEngine handles exceptions correctly', () async {
    final filePath = './views/index.jael';
    var error;
    var rendered;

    HandlerCallback callback = (err, string) {
      error = err;
      rendered = string;
    };

    final mockFileRepository = MockFileRepository();

    when(mockFileRepository.readAsString(Uri.file(filePath)))
        .thenThrow(FileSystemException('Could not find file.'));

    await JaelEngine.handler(filePath, {}, callback, mockFileRepository);

    expect(error, isA<FileSystemException>());
    expect((error as FileSystemException).message, 'Could not find file.');
    expect(rendered, null);
  });

  test('JaelEngine handles JaelErrors correctly', () async {
    final filePath = './views/index.jael';
    var error;
    var rendered;

    HandlerCallback callback = (err, string) {
      error = err;
      rendered = string;
    };

    final mockFileRepository = MockFileRepository();

    when(mockFileRepository.readAsString(Uri.file(filePath)))
        .thenThrow(jael.JaelError(jael.JaelErrorSeverity.error, 'Error', null));

    await JaelEngine.handler(filePath, {}, callback, mockFileRepository);

    expect(error, isA<jael.JaelError>());
    expect((error as jael.JaelError).message, 'Error');
    expect(rendered, null);
  });
}
