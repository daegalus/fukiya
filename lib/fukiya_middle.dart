part of fukiya;

class FukiyaMiddle {
  List<FukiyaMiddleware> middlewares;

  FukiyaMiddle() {
    middlewares = new List<FukiyaMiddleware>();
  }

  void add(FukiyaMiddleware middleware) {
    middlewares.add(middleware);
  }

  Future process(FukiyaContext context) {
    Completer completer = new Completer();
    bool done = false;
    middlewares.forEach((value) {
      if(!done)
        done = value.process(context, completer);
    });
    return completer.future;
  }
}

