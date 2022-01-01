import 'dart:io';

import 'package:dart_express/dart_express.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

class MockFileRepository extends Mock implements FileRepository {}

final mockMarkdown = '''
# Hello, world
''';

void main() {
  test('HtmlEngine has the correct extension', () {
    expect(MarkdownEngine.ext, '.md');
  });

  test('MarkdownEngine handles reading a file correctly', () async {
    final filePath = './views/index.md';
    dynamic error;
    String? rendered;

    dynamic callback(dynamic err, String? string) {
      error = err;
      rendered = string;
    }

    final mockFileRepository = MockFileRepository();

    when(mockFileRepository.readAsString(Uri.file(filePath)))
        .thenAnswer((_) async => mockMarkdown);

    await MarkdownEngine.handler(filePath, {}, callback, mockFileRepository);

    expect(error, null);
    expect(rendered, contains('<html>'));
    expect(rendered, contains('<h1>Hello, world</h1>'));
  });

  test('MarkdownEngine handles exceptions correctly', () async {
    final filePath = './views/index.md';
    dynamic error;
    String? rendered;

    dynamic callback(dynamic err, String? string) {
      error = err;
      rendered = string;
    }

    final mockFileRepository = MockFileRepository();

    when(mockFileRepository.readAsString(Uri.file(filePath)))
        .thenThrow(FileSystemException('Could not find file.'));

    await MarkdownEngine.handler(filePath, {}, callback, mockFileRepository);

    expect(error, isA<FileSystemException>());
    expect((error as FileSystemException).message, 'Could not find file.');
    expect(rendered, null);
  });
}
