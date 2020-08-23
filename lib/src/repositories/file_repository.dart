part of dart_express;

abstract class FileRepository {
  const FileRepository();

  Future<String> readAsString(Uri uri);
}

class RealFileRepository extends FileRepository {
  const RealFileRepository();

  @override
  Future<String> readAsString(Uri uri) {
    return File.fromUri(uri).readAsString();
  }
}
