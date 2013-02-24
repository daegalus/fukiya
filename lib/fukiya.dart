library fukiya;
import 'dart:io';
import 'dart:collection';
import 'dart:async';
part 'fukiya_request_handler.dart';
part 'fukiya_router.dart';
part 'fukiya_context.dart';

class Fukiya {
  HttpServer _server;
  Router _router;

  Fukiya() {
    _router = new Router();
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
    HttpServer.bind(host, port).then((HttpServer httpServer) {
      _server = httpServer;

      _server.listen((HttpRequest request) {
        FukiyaContext context = new FukiyaContext(request);
        _router.route(context);
      }, onError: (error) {
        print("[Fukiya] Error: ${error.stackTrace}");
      });

      print("[Fukiya] Listening at ${host} on port ${port}");
    });
  }

  HttpServer httpServer() {
    return _server;
  }
}

