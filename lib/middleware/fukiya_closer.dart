part of fukiya;

class FukiyaCloser implements FukiyaMiddleware {
  String getName() {
    return "FukiyaCloser";
  }

  bool process(FukiyaContext context, Completer completer) {
    completer.complete(context);
    return true;
  }
}

