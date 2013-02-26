part of fukiya;

class FukiyaMiddle {
  Map<String, FukiyaMiddleware> middlewares;

  FukiyaMiddle() {
    middlewares = new HashMap<String, FukiyaMiddleware>();
  }

  void add(FukiyaMiddleware middleware) {
    middlewares[middleware.getName()] = middleware;
  }

  Future process(FukiyaContext context) {
    Completer completer = new Completer();
    bool done = false;
    middlewares.forEach((key, value) {
      if(!done)
        done = value.process(context, completer);
    });
    return completer.future;
  }

  FukiyaMiddleware remove(String middlewareName) {
    return middlewares.remove(middlewareName);
  }
}

