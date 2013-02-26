library fukiya;
import 'dart:io';
import 'dart:collection';
import 'dart:async';
part 'fukiya_request_handler.dart';
part 'fukiya_router.dart';
part 'fukiya_context.dart';
part 'fukiya_middle.dart';
part 'middleware/fukiya_middleware.dart';
part 'middleware/fukiya_formparser.dart';
part 'middleware/fukiya_closer.dart';

class Fukiya {
  HttpServer _server;
  FukiyaRouter _router;
  FukiyaMiddle _middle;

  Fukiya() {
    _router = new FukiyaRouter();
    _middle = new FukiyaMiddle();
  }

  void get(String path, Function handler) {
    _router.addRoute("GET", path, handler);
  }

  void post(String path, Function handler) {
    _router.addRoute("POST", path, handler);
  }

  void put(String path, Function handler) {
    _router.addRoute("PUT", path, handler);
  }

  void delete(String path, Function handler) {
    _router.addRoute("DELETE", path, handler);
  }

  void staticFiles(String basePath) {
    _router.useStaticFileHandling = true;
    _router.staticFilePath = basePath;
  }

  void listen(host, port) {
    use(new FukiyaCloser());
    HttpServer.bind(host, port).then((HttpServer httpServer) {
      _server = httpServer;

      _server.listen((HttpRequest request) {
        FukiyaContext context = new FukiyaContext(request);
        _middle.process(context).then((innerContext) {
          _router.route(innerContext);
        });

      }, onError: (error) {
        print("[Fukiya] Error: ${error.stackTrace}");
      });

      print("[Fukiya] Listening at ${host} on port ${port}");
    });
  }

  void use(FukiyaMiddleware middleware) {
    _middle.add(middleware);
  }

  HttpServer httpServer() {
    return _server;
  }
}

