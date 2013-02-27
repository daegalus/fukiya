part of fukiya;

class FukiyaFileParser implements FukiyaMiddleware {

  String getName() {
    return "FukiyaFileParser";
  }

  bool process(FukiyaContext context, Completer completer) {
    var contentType = context.request.headers.contentType;
    if((contentType.primaryType != "text" && contentType.subType != "plain") ||
       (contentType.primaryType != "application" && (contentType.subType != "json" || contentType.subType != "x-www-form-urlencoded")) ||
       (contentType.primaryType != "multipart" && contentType.subType != "form-data")) {
      _parseFileBody(context, completer);
      return true;
    }
    return false;
  }

  void _parseFileBody(FukiyaContext context, Completer completer) {
    List<int> lines = new List<int>();
    context.request.listen((List<int> data) {
                     lines.addAll(data);
                   },
                   onError: (e) => print("[Fukiya][FormParser]${e}"),
                   onDone: () {
                     context.parsedBody['contentType'] = context.request.headers.contentType.primaryType.concat("/").concat(context.request.headers.contentType.subType);
                     context.parsedBody['data'] = lines;
                     completer.complete(context);
                   });
  }
}





