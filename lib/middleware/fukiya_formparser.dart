part of fukiya;

class FukiyaFormParser implements FukiyaMiddleware {

  Base64Decoder b64d = new Base64Decoder();

  String getName() {
    return "FukiyaFormParser";
  }

  bool process(FukiyaContext context, Completer completer) {
    var contentType = context.request.headers.contentType;
    if(contentType != null && (context.request.method == "POST" || context.request.method == "PUT") &&
       (contentType.primaryType == "multipart" && contentType.subType == "form-data")) {
      _parseMultiPartBody(context, completer);
      return true;
    } else if(contentType != null  && (context.request.method == "POST" || context.request.method == "PUT") &&
              (contentType.primaryType == "application" && contentType.subType == "x-www-form-urlencoded")) {
      _parseUrlEncodedBody(context, completer);
      return true;
    }
    return false;
  }

  void _parseMultiPartBody(FukiyaContext context, Completer completer) {
    var state = 0;
    List<int> data = new List<int>();
    Formler formler;
    context.request.listen((List<int> bits) {
                     data.addAll(bits);
                   },
                   onError: (e) => print("[Fukiya][FormParser]${e}"),
                   onDone: () {
                     formler = new Formler(data, context.request.headers.contentType.parameters['boundary']);
                     context.parsedBody = formler.parse();
                     completer.complete(context);
                   });
  }

  void _parseUrlEncodedBody(FukiyaContext context, Completer completer) {
    List<int> data = new List<int>();
    context.request.listen((List<int> bits) {
                     data.addAll(bits);
                   },
                   onError: (e) => print("[Fukiya][FormParser]${e}"),
                   onDone: () {
                     String body = new String.fromCharCodes(data);
                     context.parsedBody = Formler.parseUrlEncoded(body);
                     completer.complete(context);
                   });
  }
}

