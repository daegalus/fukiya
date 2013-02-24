part of fukiya;

class Router {
  List<FukiyaRequestHandler> _routes;
  bool useStaticFileHandling;
  String staticFilePath;

  Router() {
    _routes = new List<FukiyaRequestHandler>();
    useStaticFileHandling = false;
    staticFilePath = "";
  }

  void addRoute(String method, String path, Function handler) {
    _routes.add(new FukiyaRequestHandler(method, path, handler));
  }

  void route(FukiyaContext context) {
    List<FukiyaRequestHandler> filteredRoutes = _routes.where((FukiyaRequestHandler route) {
      return route.method == context.request.method && route.matches(context);
    }).toList();

    var static = false;
    if (useStaticFileHandling && context.request.method == "GET") {
      var file = new File(staticFilePath.concat(context.request.uri.path));
      file.exists().then((exists) {
        if (exists) {
          file.readAsBytes().then((value) {
            context.response.add(value.toList());
            context.response.close();
          }, onError:(error) => print(error));

        } else if (!filteredRoutes.isEmpty) {
          filteredRoutes.single.handle(context);
        }
      });
    } else {
      filteredRoutes.single.handle(context);
    }
  }
}