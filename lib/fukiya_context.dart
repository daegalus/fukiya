part of fukiya;

class FukiyaContext {
  HttpRequest request;
  HttpResponse response;
  Map params;
  Map parsedBody;
  Map data;

  /**
   * Creates a [FukiyaContext] from a provided [HttpRequest]. It allows for additional functionality ontop of the
   * standard classes.
   */
  FukiyaContext(HttpRequest request) {
    this.request = request;
    response = request.response;
    params = request.uri.queryParameters;
    data = new HashMap();
    parsedBody = new HashMap();
  }

  /**
   * Sends the string as output and closes the response.
   */
  void send(String output) {
    response.write(output);
    response.done.catchError((e) => print("Error sending response ${e}"));
    response.close();
  }

  /**
   * Sends a 302 Moved Temporarily redirect as a response to the URL provided.
   */
  void redirect(String url) {
    response.statusCode = HttpStatus.MOVED_TEMPORARILY;
    response.headers.add('Location',url);
    response.close();
  }
}