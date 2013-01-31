part of fukiya;

class MethodMatcher {
  String _method;
  String _path;

  MethodMatcher(String method, String path) {
    _method = method;
    _path = path;
  }

  bool method_matcher(HttpRequest request) {
     return (request.method == _method && request.path == _path);
  }
}