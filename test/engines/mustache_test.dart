import 'dart:io';

import 'package:dart_express/dart_express.dart';
import 'package:dart_express/src/engines/mustache.dart';
import 'package:dart_express/src/repositories/file_repository.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

class MockFileRepository extends Mock implements FileRepository {}

final mockMustache = '''
<html>
<head>
  <title>Mock HTML Title</title>
</head>
<body>
  {{#first_name}}
    <h1>Hello, {{first_name}}</h1>
  {{/first_name}}
  {{^first_name}}
    <h1>Hello, World</h1>
  {{/first_name}}
</body>
</html>
''';

void main() {
  test('MustacheEngine has the correct extension', () {
    expect(MustacheEngine.ext, '.mustache');
  });

  test('MustacheEngine handles reading a file correctly', () async {
    final filePath = './views/index.mustache';
    var error;
    var rendered;

    HandlerCallback callback = (err, string) {
      error = err;
      rendered = string;
    };

    final mockFileRepository = MockFileRepository();

    when(mockFileRepository.readAsString(Uri.file(filePath))).thenAnswer((_) async => mockMustache);

    await MustacheEngine.handler(filePath, {}, callback, mockFileRepository);

    expect(error, null);
    expect(rendered, contains('<html>'));
    expect(rendered, contains('Hello, World'));
  });

  test('MustacheEngine handles passing locals into template', () async {
    final filePath = './views/index.mustache';
    var error;
    var rendered;

    HandlerCallback callback = (err, string) {
      error = err;
      rendered = string;
    };

    final mockFileRepository = MockFileRepository();

    when(mockFileRepository.readAsString(Uri.file(filePath))).thenAnswer((_) async => mockMustache);

    await MustacheEngine.handler(filePath, {'first_name': 'Devin'}, callback, mockFileRepository);

    expect(error, null);
    expect(rendered, contains('<html>'));
    expect(rendered, contains('Hello, Devin'));
  });

  test('MustacheEngine handles exceptions', () async {
    final filePath = './views/index.mustache';
    var error;
    var rendered;

    HandlerCallback callback = (err, string) {
      error = err;
      rendered = string;
    };

    final mockFileRepository = MockFileRepository();

    when(mockFileRepository.readAsString(Uri.file(filePath)))
        .thenThrow(FileSystemException('Could not find file'));

    await MustacheEngine.handler(filePath, {'first_name': 'Devin'}, callback, mockFileRepository);

    expect(error, isA<FileSystemException>());
    expect((error as FileSystemException).message, 'Could not find file');
    expect(rendered, null);
  });
}
