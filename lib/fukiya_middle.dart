part of fukiya;

class FukiyaMiddle {
  static final _logger = LoggerFactory.getLoggerFor(FukiyaMiddle);

  List<FukiyaMiddleware> middlewares;

  FukiyaMiddle() {
    middlewares = new List<FukiyaMiddleware>();
  }

  void _add(FukiyaMiddleware middleware) {
    middlewares.add(middleware);
  }

  Future _process(FukiyaContext context) {
    Iterable<Future> middleFutures = middlewares.map((middleware) {
      return new Future(() {
        runZoned(() {
          middleware.process(context);
        },
        onError: (e) {
          _logger.error("Received the following error when running middleware \"${middleware.getName()}\".");
          _logger.error(e);
        });
      });
    });

    return Future.wait(middleFutures);
  }
}

