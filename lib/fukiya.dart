library fukiya;
import 'dart:io';
import 'dart:collection';
import 'dart:async';
import 'dart:json' as JSON;
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:formler/formler.dart';
import 'package:logging/logging.dart';
import 'package:static_file_handler/static_file_handler.dart';
part 'fukiya_request_handler.dart';
part 'fukiya_router.dart';
part 'fukiya_context.dart';
part 'fukiya_middle.dart';
part 'middleware/fukiya_middleware.dart';
part 'middleware/fukiya_formparser.dart';
part 'middleware/fukiya_jsonparser.dart';
part 'middleware/fukiya_fileparser.dart';
part 'middleware/fukiya_closer.dart';

class Fukiya {
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
   * Activates static file handling and uses the [basePath] as a prefix to lookup the file.
   */
  void staticFiles(String basePath) {
    _router.useStaticFileHandling = true;
    _router.staticFilePath = basePath;
    _router.staticFileHandler = new StaticFileHandler(basePath);
  }

  /**
   * Adds additional mime types to the static file handler's mime types list in addition to the existing ones.
   */
  void addMimeType(String extension, String mimeType) {
    if (_router.staticFileHandler != null) {
      _router.staticFileHandler.addMIMETypes({ "$extension": mimeType});
    }
  }

  /**
   * Adds additional mime types to the static file handler's mime types list in addition to the existing ones.
   */
  void addMimeTypes(Map<String, String> mimeTypes) {
    if (_router.staticFileHandler != null) {
      _router.staticFileHandler.addMIMETypes(mimeTypes);
    }
    print(_router.staticFileHandler);
  }

  /**
   * Creates an HttpServer that binds to the [host] and [port] provided. This also activates listening.
   */
  void listen(host, port) {
    use(new FukiyaCloser());
    HttpServer.bind(host, port).then((HttpServer httpServer) {
      _server = httpServer;

      _server.listen((HttpRequest request) {
        FukiyaContext context = new FukiyaContext(request);
        _middle._process(context).then((innerContext) {
          _router._route(innerContext);
        });

      }, onError: (error) {
        print("[Fukiya] Error: ${error.stackTrace}");
      });

      print("[Fukiya] Listening at ${host} on port ${port}");
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

