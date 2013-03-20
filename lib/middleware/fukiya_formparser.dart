part of fukiya;

class FukiyaFormParser implements FukiyaMiddleware {

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
    List<String> lines = new List<String>();
    context.request.transform(new StringDecoder())
                   .transform(new LineTransformer())
                   .listen((String line) {
                     state = _readMultiPartBody(line, context, state);
                   },
                   onError: (e) => print("[Fukiya][FormParser]${e}"),
                   onDone: () {
                     context.parsedBody.remove('currentName');
                     context.parsedBody.remove('boundary');
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

  const BOUNDARY = 0;
  const HEADER_FIELD = 1;
  const PART_FIELD_DATA = 2;
  const PART_FILE_DATA = 3;
  const END = 4;

  int _readMultiPartBody(String line, FukiyaContext context, int state) {
    switch(state) {
      case BOUNDARY:
        context.parsedBody['boundary'] = context.request.headers.contentType.parameters['boundary'];
        if(line.toLowerCase() == "--${context.parsedBody['boundary']}") {
          state = HEADER_FIELD;
        } else {
          state = END;
        }
        break;
      case HEADER_FIELD:
        var dispRegex = new RegExp(r'Content-Disposition: ([\S]+); name="([\S]+)"');
        var dispFileRegex = new RegExp(r'Content-Disposition: ([\S]+); name="([\S]+)"; filename="([\w\.]+)"');

        if(dispFileRegex.hasMatch(line)) {
          context.parsedBody['currentName'] = dispRegex.firstMatch(line).group(2);
          context.parsedBody[context.parsedBody['currentName']] = new HashMap();
          context.parsedBody[context.parsedBody['currentName']]['filename'] = dispFileRegex.firstMatch(line).group(3);
          context.parsedBody[context.parsedBody['currentName']]['data'] = new List();
          state = PART_FILE_DATA;
        } else if(dispRegex.hasMatch(line)) {
           context.parsedBody['currentName'] = dispRegex.firstMatch(line).group(2);
           context.parsedBody[context.parsedBody['currentName']] = "";
           state = PART_FIELD_DATA;
        } else {
          state = END;
        }
        break;
      case PART_FIELD_DATA:
        if(line == "") {
          break;
        }
        if(line.toLowerCase() == "--${context.parsedBody['boundary']}") {
          state = HEADER_FIELD;
          break;
        }
        if(line.toLowerCase() == "--${context.parsedBody['boundary']}--") {
          state = END;
          break;
        }

        context.parsedBody[context.parsedBody['currentName']] = context.parsedBody[context.parsedBody['currentName']].concat(line);
        break;
      case PART_FILE_DATA:
        if(line == "") {
          break;
        }
        var typeRegex = new RegExp(r'Content-Type: ([\S]+)');
        if(typeRegex.hasMatch(line)) {
          context.parsedBody[context.parsedBody['currentName']]['contentType'] = typeRegex.firstMatch(line).group(1);
          break;
        }
        if(line.toLowerCase() == "--${context.parsedBody['boundary']}") {
          state = HEADER_FIELD;
          break;
        }
        if(line.toLowerCase() == "--${context.parsedBody['boundary']}--") {
          state = END;
          break;
        }

        context.parsedBody[context.parsedBody['currentName']]['data'].addAll(line.codeUnits);
        context.parsedBody[context.parsedBody['currentName']]['data'].addAll("\n".codeUnits);

        break;
      case END:
        break;
    }
    return state;
  }

  void _readUrlEncodedBody(String content, FukiyaContext context) {
    List<String> segments = content.split("&");

    for(String segment in segments) {
      List<String> pair = segment.split('=');
      context.parsedBody[pair[0]] = pair[1];
    }
  }

}

