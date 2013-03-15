part of fukiya;

class FukiyaRequestHandler {
  String method;
  String path;
  Function _handler;

  FukiyaRequestHandler(String method, String path, Function handler) {
    this.method = method;
    this.path = path;
    _handler = handler;
  }

  bool matches(FukiyaContext context) {
    if(context.request.method == method) {
      List<String> pathSegments = path.split('/');
      List<String> reqPathSegments = context.request.uri.path.split('/');

      if(pathSegments.length == reqPathSegments.length) {
        for(int i = 0; i<pathSegments.length; i++) {
          String pathSegment = pathSegments[i];
          String reqPathSegment = reqPathSegments[i];
          bool matched = _match(pathSegment, reqPathSegment, context);
          if(!matched)
            return false;
        }
        return true;
      }
      return false;
    } else {
      return false;
    }
  }

  bool _match(String pathNode, String reqNode, FukiyaContext context) {
    if (pathNode.startsWith(':') && reqNode != "" && reqNode != 'favicon.ico') {
      context.request.queryParameters[pathNode.replaceAll(':', '')] = reqNode;
      return true;
    }
    return (pathNode.startsWith(':') && reqNode != "" && reqNode != 'favicon.ico') ? true : pathNode == reqNode;
  }

  void handle(FukiyaContext context) {
    _handler(context);
  }
}