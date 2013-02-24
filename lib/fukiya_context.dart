part of fukiya;

class FukiyaContext {
  HttpRequest request;
  HttpResponse response;
  Map params;
  Map data;

  FukiyaContext(HttpRequest request) {
    this.request = request;
    response = request.response;
    params = request.queryParameters;
  }

  void send(String output) {
    response.add(output.charCodes);
    response.close();
  }
}