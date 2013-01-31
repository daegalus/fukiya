library fukiya;
import 'dart:io';
part 'method_matcher.dart';
part 'static_file_handler.dart';


class Fukiya {
  HttpServer _server;

  Fukiya() {
    _server = new HttpServer();
  }

  void get(String path, Function handler) {
    MethodMatcher getMatcher = new MethodMatcher("GET", path);
    _server.addRequestHandler(getMatcher.method_matcher, handler);
  }

  void post(String path, Function handler) {
    MethodMatcher getMatcher = new MethodMatcher("POST", path);
    _server.addRequestHandler(getMatcher.method_matcher, handler);
  }

  void put(String path, Function handler) {
    MethodMatcher getMatcher = new MethodMatcher("PUT", path);
    _server.addRequestHandler(getMatcher.method_matcher, handler);
  }

  void delete(String path, Function handler) {
    MethodMatcher getMatcher = new MethodMatcher("DELETE", path);
    _server.addRequestHandler(getMatcher.method_matcher, handler);
  }

  void staticFiles(String basePath) {
    _server.defaultRequestHandler = new StaticFileHandler(basePath).onRequest;
  }

  void listen(host, port) {
    _server.listen(host, port);
    print("[Fukiya] Listening at ${host} on port ${port}");
  }

  void listenOn(ServerSocket serverSocket) {
    _server.listenOn(serverSocket);
    print("[Fukiya] Listening on port ${serverSocket.port}");
  }

  HttpServer httpServer() {
    return _server;
  }
}

