part of fukiya;

class FukiyaContext {
  HttpRequest request;
  HttpResponse response;
  Map params;
  Map parsedBody;
  Map data;

  FukiyaContext(HttpRequest request) {
    this.request = request;
    response = request.response;
    params = request.queryParameters;
    data = new HashMap();
    parsedBody = new HashMap();
  }

  void send(String output) {
    response.write(output);
    response.done.catchError((e) => print("Error sending response ${e}"));
    response.close();
  }

  void redirect(String url) {
    response.statusCode = HttpStatus.MOVED_TEMPORARILY;
    response.headers.add('Location',url);
    response.close();
  }
}