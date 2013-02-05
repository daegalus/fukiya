part of fukiya;

class MethodMatcher {
  String _method;
  String _path;

  MethodMatcher(String method, String path) {
    _method = method;
    _path = path;
  }

  bool method_matcher(HttpRequest request) {
    if(request.method == _method) {
      List<String> pathSegments = _path.split('/');
      List<String> reqPathSegments = request.path.split('/');

      if(pathSegments.length == reqPathSegments.length) {
        for(int i = 0; i<pathSegments.length; i++) {
          String pathSegment = pathSegments[i];
          String reqPathSegment = reqPathSegments[i];
          bool matched = _match(pathSegment, reqPathSegment, request);
          if(!matched)
            return false;
        }
        return true;
      }
    } else {
      return false;
    }
  }

  bool _match(String pathNode, String reqNode, HttpRequest request) {
    if (pathNode.startsWith(':') && reqNode != 'favicon.ico') {
      request.queryParameters[pathNode.replaceAll(':', '')] = reqNode;
      return true;
    }
    return (pathNode.startsWith(':') && reqNode != 'favicon.ico') ? true : pathNode == reqNode;
  }
}