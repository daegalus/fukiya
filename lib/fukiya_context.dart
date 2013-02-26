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
    response.add(output.charCodes);
    response.close();
  }
}