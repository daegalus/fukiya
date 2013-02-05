part of fukiya;

class StaticFileHandler {
  String _staticPath;

  StaticFileHandler(String path) {
    _staticPath = path;
  }

  onRequest(HttpRequest request, HttpResponse response) {
    var file = new File(_staticPath.concat(request.uri));
    file.exists().then((found) {
      if (found && request.method == "GET") {
        file.readAsBytes().then((value) {
          response.outputStream.write(value);
          response.outputStream.close();
        }, onError:(error) => print(error));

      } else {
        response.statusCode = 404;
        response.outputStream.close();
      }
    });
  }
}

