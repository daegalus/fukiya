part of fukiya;

class FukiyaMiddle {
  List<FukiyaMiddleware> middlewares;

  FukiyaMiddle() {
    middlewares = new List<FukiyaMiddleware>();
  }

  void _add(FukiyaMiddleware middleware) {
    middlewares.add(middleware);
  }

  Future _process(FukiyaContext context) {
    Completer completer = new Completer();
    bool done = false;
    middlewares.forEach((value) {
      if(!done)
        done = value.process(context, completer);
    });
    return completer.future;
  }
}

