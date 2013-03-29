part of fukiya;

class FukiyaRouter {
  List<FukiyaRequestHandler> _routes;
  bool useStaticFileHandling;
  String staticFilePath;

  FukiyaRouter() {
    _routes = new List<FukiyaRequestHandler>();
    useStaticFileHandling = false;
    staticFilePath = "";
  }

  void addRoute(String method, String path, Function handler) {
    _routes.add(new FukiyaRequestHandler(method, path, handler));
  }

  void route(FukiyaContext context) {
    List<FukiyaRequestHandler> filteredRoutes = _routes.where((FukiyaRequestHandler route) {
      return (route.method == context.request.method) && route.matches(context);
    }).toList();

    FukiyaRequestHandler finalRoute = prioritizeRouter(context, filteredRoutes);

    var static = false;
    if (useStaticFileHandling && context.request.method == "GET") {
      var file = new File(staticFilePath + context.request.uri.path);
      file.exists().then((exists) {
        if (exists) {
          file.readAsBytes().then((value) {
            context.response.writeBytes(value.toList());
            context.response.done.catchError((e) => print("File Response error: ${e}"));
            context.response.close();
          }, onError:(error) => print(error));

        } else if (finalRoute != null) {
          finalRoute.handle(context);
        } else {
          context.response.statusCode = 404;
          context.response.close();
        }
      });
    } else if (finalRoute != null) {
      finalRoute.handle(context);
    } else {
      context.response.statusCode = 404;
      context.response.close();
    }
  }

  FukiyaRequestHandler prioritizeRouter(FukiyaContext context, List<FukiyaRequestHandler> routes) {
    Map<FukiyaRequestHandler, int> mapPriorities = new HashMap<FukiyaRequestHandler, int>();

    for(FukiyaRequestHandler handler in routes) {
      List<String> pathSegments = handler.path.split('/');
      List<String> reqPathSegments = context.request.uri.path.split('/');

      for(int i = 0; i<pathSegments.length; i++) {
        String pathSegment = pathSegments[i];
        String reqPathSegment = reqPathSegments[i];

        mapPriorities.putIfAbsent(handler, () => 0);

        if(pathSegment == reqPathSegment) {
          mapPriorities[handler] += 1;
        } else if(pathSegment.startsWith(':')) {
          mapPriorities[handler] += 0.8; //for cases where /testing/:somevalue and /:somevalue/:anothervalue happens
        }
      }
    }

    var values = mapPriorities.values.toList();
    values.sort((a,b) {
       return b-a;
    });

    for(FukiyaRequestHandler handler in mapPriorities.keys) {
      if(mapPriorities[handler] == values[0]) {
        return handler;
      }
    }
  }
}