library fukiya;
import 'dart:io';
import 'dart:collection';
import 'dart:async';
import 'dart:convert';
import 'package:json/json.dart' as JSON;
import 'package:log4dart/log4dart.dart';
import 'package:mime/mime.dart';
import 'package:http_server/http_server.dart';
part 'fukiya_request_handler.dart';
part 'fukiya_router.dart';
part 'fukiya_context.dart';
part 'fukiya_middle.dart';
part 'middleware/fukiya_middleware.dart';
part 'middleware/fukiya_bodyparser.dart';

class Fukiya {
  
  static final _logger = LoggerFactory.getLoggerFor(Fukiya);
  
  HttpServer _server;
  FukiyaRouter _router;
  FukiyaMiddle _middle;

  Fukiya() {
    _router = new FukiyaRouter();
    _middle = new FukiyaMiddle();
  }

  /**
   * Creates a handler that handles a GET method call for the provided URI path.
   *
   * Takes a [path] of the uri to handle and a [handler] function that gets called when the path matches.
   */
  void get(String path, Function handler) {
    _router._addRoute("GET", path, handler);
  }

  /**
   * Creates a handler that handles a POST method call for the provided URI path.
   *
   * Takes a [path] of the uri to handle and a [handler] function that gets called when the path matches.
   */
  void post(String path, Function handler) {
    _router._addRoute("POST", path, handler);
  }

  /**
   * Creates a handler that handles a PUT method call for the provided URI path.
   *
   * Takes a [path] of the uri to handle and a [handler] function that gets called when the path matches.
   */
  void put(String path, Function handler) {
    _router._addRoute("PUT", path, handler);
  }

  /**
   * Creates a handler that handles a DELETE method call for the provided URI path.
   *
   * Takes a [path] of the uri to handle and a [handler] function that gets called when the path matches.
   */
  void delete(String path, Function handler) {
    _router._addRoute("DELETE", path, handler);
  }
  
  /**
   * Creates a handler that handles a OPTIONS method call for the provided URI path.
   *
   * Takes a [path] of the uri to handle and a [handler] function that gets called when the path matches.
   */
  void options(String path, Function handler) {
    _router._addRoute("OPTIONS", path, handler);
  }

  /**
   * Activates static file handling and uses the [basePath] as a prefix to lookup the file.
   */
  void staticFiles(String basePath) {
    VirtualDirectory vd = new VirtualDirectory(basePath);
    vd.allowDirectoryListing = false;
    _router.useStaticFileHandling = true;
    _router.virtualDir = vd;
  }

  /**
   * Creates an HttpServer that binds to the [host] and [port] provided. This also activates listening.
   */
  void listen(host, port) {
    HttpServer.bind(host, port).then((HttpServer httpServer) {
      _server = httpServer;

      _server.listen((HttpRequest request) {
        FukiyaContext context = new FukiyaContext(request);
        _middle._process(context).then((list) {
          _router._route(context);
        });

      }, onError: (error) {
        _logger.error("Error: ${error.stackTrace}");
      });

      _logger.info("Listening at ${host} on port ${port}");
    });
  }

  /**
   * Adds a provided [middleware] to the active set of middlewares that process and work on every request if it matches
   * the conditions set in the middleware.
   */
  void use(FukiyaMiddleware middleware) {
    _middle._add(middleware);
  }

  /**
   * Returns the local [HttpServer] inside the Fukiya instance if you want it for direct access.
   */
  HttpServer httpServer() {
    return _server;
  }

  /**
   * Shuts down the HttpServer.
   */
  void stop() {
    _server.close();
  }
}

