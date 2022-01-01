import 'dart:io';

import 'package:dart_express/dart_express.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

class MockFileRepository extends Mock implements FileRepository {}

final mockHtml = '''
<html>
<head>
  <title>Mock HTML Title</title>
</head>
<body>
  <h1>Hello, world</h1>
</body>
</html>
''';

void main() {
  test('HtmlEngine has the correct extension', () {
    expect(HtmlEngine.ext, '.html');
  });

  test('HtmlEngine handles reading a file correctly', () async {
    final filePath = './views/index.html';
    dynamic error;
    String? rendered;

    dynamic callback(dynamic err, String? string) {
      error = err;
      rendered = string;
    }

    final mockFileRepository = MockFileRepository();

    when(mockFileRepository.readAsString(Uri.file(filePath)))
        .thenAnswer((_) async => mockHtml);

    await HtmlEngine.handler(filePath, {}, callback, mockFileRepository);

    expect(error, null);
    expect(rendered, contains('<html>'));
  });

  test('HtmlEngine handles exceptions correctly', () async {
    final filePath = './views/index.html';
    dynamic error;
    String? rendered;

    dynamic callback(dynamic err, String? string) {
      error = err;
      rendered = string;
    }

    final mockFileRepository = MockFileRepository();

    when(mockFileRepository.readAsString(Uri.file(filePath)))
        .thenThrow(FileSystemException('Could not find file.'));

    await HtmlEngine.handler(filePath, {}, callback, mockFileRepository);

    expect(error, isA<FileSystemException>());
    expect((error as FileSystemException).message, 'Could not find file.');
    expect(rendered, null);
  });
}
