part of fukiya;

abstract class FukiyaMiddleware {
  bool process(FukiyaContext context, Completer completer);
  String getName();
}

