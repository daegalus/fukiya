part of fukiya;

class FukiyaBodyParser implements FukiyaMiddleware {

  String getName() {
    return "FukiyaBodyParser";
  }

  bool process(FukiyaContext context) {
    HttpBodyHandler.processRequest(context.request).then((HttpRequestBody body) {
      switch(body.type) {
        case "text":
        case "binary":
          var map = new HashMap();
          map["data"] = body.body;
          context.parsedBody = map;
          break;
        case "text":
          context.textBody = body.body;
          break;
        case "json":
        case "form":
          context.parsedBody = body.body;
          break;
        default:
          break;
      }
    });
  }
}

