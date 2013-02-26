part of fukiya;

class FukiyaFormParser implements FukiyaMiddleware {
  String getName() {
    return "FukiyaFormParser";
  }

  bool process(FukiyaContext context, Completer completer) {
    var contentType = context.request.headers.contentType;
    if((context.request.method == "POST" || context.request.method == "PUT") &&
       (contentType.primaryType == "multipart" && contentType.subType == "form-data")) {
      _parseMultiPartBody(context, completer);
      return true;
    } else if((context.request.method == "POST" || context.request.method == "PUT") &&
              (contentType.primaryType == "application" && contentType.subType == "x-www-form-urlencoded")) {
      _parseUrlEncodedBody(context, completer);
      return true;
    }
    return false;
  }

  void _parseMultiPartBody(FukiyaContext context, Completer completer) {
    List<String> lines = new List<String>();
    context.request.transform(new StringDecoder())
                   .transform(new LineTransformer())
                   .listen((String line) {
                     lines.add(line);
                   },
                   onError: (e) => print("[Fukiya][FormParser]${e}"),
                   onDone: () {
                     _readMultiPartBody(lines, context);
                     completer.complete(context);
                   });
  }

  void _parseUrlEncodedBody(FukiyaContext context, Completer completer) {
    List<String> lines = new List<String>();
    context.request.transform(new StringDecoder())
                   .transform(new LineTransformer())
                   .listen((String line) {
                     lines.add(line);
                   },
                   onError: (e) => print("[Fukiya][FormParser]${e}"),
                   onDone: () {
                     _readUrlEncodedBody(lines.first, context);
                     completer.complete(context);
                   });
  }

  void _readMultiPartBody(List<String> content, FukiyaContext context) {
    Map formMap = new HashMap();
    String seperator = context.request.headers.contentType.parameters['boundary'];

    List<String> segment = new List<String>();
    bool insideSegment = false;
    var disposition = "";
    var name = "";
    var filename="";
    var fileContentType="";
    var fileContentTransfer="";
    for(String line in content) {

      if(line.toLowerCase().startsWith("--${seperator}")) {
        if(disposition != "" && filename == "") {
          context.parsedBody[name] = segment.join("\n");
          segment.clear();
        } else if (disposition != "" && filename != "") {
          context.parsedBody[name] = segment.join("\n").charCodes;
        }
        disposition = "";
        name = "";
        filename = "";
        fileContentType = "";
        fileContentTransfer = "";
        insideSegment = true;
        if(line.toLowerCase() == "--${seperator}--") {
          break;
        }
      } else if(insideSegment && line.startsWith("Content-Disposition")) {
        var dispRegex = new RegExp(r'Content-Disposition: ([\S]+); name="([\S]+)"');
        var dispFileRegex = new RegExp(r'Content-Disposition: ([\S]+); name="([\S]+)"; filename="([\w\.]+)"');

        for(Match match in dispRegex.allMatches(line)) {
          disposition = match.group(1);
          name = match.group(2);
        }

        for(Match match in dispFileRegex.allMatches(line)) {
          disposition = match.group(1);
          name = match.group(2);
          filename = match.group(3);
        }
      } else if(insideSegment && filename != "" && line != "") {
        var type = new RegExp(r'Content-Type: ([\S]+)');

        if(type.hasMatch(line)) {
          fileContentType = type.firstMatch(line);
        } else {
          segment.add(line);
        }
      } else if(insideSegment && line != "") {
        segment.add(line);
      }
    }
  }

  void _readUrlEncodedBody(String content, FukiyaContext context) {
    List<String> segments = content.split("&");

    for(String segment in segments) {
      List<String> pair = segment.split('=');
      context.parsedBody[pair[0]] = pair[1];
    }
  }

}

