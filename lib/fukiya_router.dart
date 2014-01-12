part of fukiya;

class FukiyaRouter {
  List<FukiyaRequestHandler> _routes;
  bool useStaticFileHandling;
  VirtualDirectory virtualDir;

  FukiyaRouter() {
    _routes = new List<FukiyaRequestHandler>();
    useStaticFileHandling = false;
    virtualDir = null;
  }

  void _addRoute(String method, String path, Function handler) {
    _routes.add(new FukiyaRequestHandler(method, path, handler));
  }

  void _route(FukiyaContext context) {
    List<FukiyaRequestHandler> filteredRoutes = _routes.where((FukiyaRequestHandler route) {
      return (route.method == context.request.method) && route._matches(context);
    }).toList();

    FukiyaRequestHandler finalRoute = prioritizeRouter(context, filteredRoutes);

    if (useStaticFileHandling && virtualDir != null && context.request.method == "GET") {
      print(virtualDir.root + context.request.uri.path);
      var file = new File(virtualDir.root + context.request.uri.path);
      file.exists().then((exists) {
        if (exists) {
          virtualDir.serveRequest(context.request);
        } else if (finalRoute != null) {
          finalRoute._handle(context);
        } else {
          context.response.statusCode = HttpStatus.NOT_FOUND;
          context.response.close();
        }
      });
    } else if (finalRoute != null) {
      finalRoute._handle(context);
    } else {
      context.response.statusCode = HttpStatus.NOT_FOUND;
      context.response.close();
    }
  }

  FukiyaRequestHandler prioritizeRouter(FukiyaContext context, List<FukiyaRequestHandler> routes) {
    Map<FukiyaRequestHandler, num> mapPriorities = new HashMap<FukiyaRequestHandler, num>();

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