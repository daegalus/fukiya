library fukiyaGetTests;
import 'dart:io';
import 'dart:isolate';
import 'dart:async';
import 'package:unittest/unittest.dart';

class FukiyaGetTests {
  static HttpClient client = new HttpClient();

  static Future<bool> runTests() {
    Completer completer = new Completer();
    group('[GET TESTS]', () {
      test('Simple GET Request', () {
        String finalString = "";
        var atest = expectAsync0(() {
          client.get("127.0.0.1", 3333, "/").then((HttpClientRequest request) {
            return request.close();

          }).then((HttpClientResponse response) {
            response.transform(new StringDecoder())
            .transform(new LineTransformer())
            .listen((String result) {
              finalString += result;
            },
            onDone: () {
              expect(finalString, equals("GET OK"));
            });
          });
        });
        atest();
      });

      test('Simple GET Request with Path', () {
        String finalString = "";
        var atest = expectAsync0(() {
          client.get("127.0.0.1", 3333, "/testing").then((HttpClientRequest request) {
            return request.close();

          }).then((HttpClientResponse response) {
            response.transform(new StringDecoder())
            .transform(new LineTransformer())
            .listen((String result) {
              finalString += result;
            },
            onDone: () {
              expect(finalString, equals("GET OK - testing"));
            });
          });
        });
        atest();
      });

      test('Complex GET Request with Dynamic Path', () {
        String finalString = "";

        var atest = expectAsync0(() {
          client.get("127.0.0.1", 3333, "/3727328732").then((HttpClientRequest request) {
            return request.close();

          }).then((HttpClientResponse response) {
            response.transform(new StringDecoder())
            .transform(new LineTransformer())
            .listen((String result) {
              finalString += result;
            },
            onDone: () {
              expect(finalString, equals("Dynamic GET OK 3727328732"));
            });
          });
        });
        atest();
      });
    });

    test('Simple GET Request w/ Multiple value matchers', () {
      String finalString = "";
      var atest = expectAsync0(() {
        client.get("127.0.0.1", 3333, "/test/test2/test3").then((HttpClientRequest request) {
          return request.close();

        }).then((HttpClientResponse response) {
          response.transform(new StringDecoder())
          .transform(new LineTransformer())
          .listen((String result) {
            finalString += result;
          },
          onDone: () {
            expect(finalString, equals("Test"));
          });
        });
      });
      atest();
    });

    test('Simple GET Static File and overrides dynamic get', () {
      String finalString = "";
      var atest = expectAsync0(() {
        client.get("127.0.0.1", 3333, "/something.txt").then((HttpClientRequest request) {
          return request.close();

        }).then((HttpClientResponse response) {
          response.transform(new StringDecoder())
          .transform(new LineTransformer())
          .listen((String result) {
            finalString += result;
          },
          onDone: () {
            expect(finalString, equals("Testing 123;"));
          });
        });
      });
      atest();
    });

    test('Simple GET Json Request', () {
      String finalString = "";
      var atest = expectAsync0(() {
        client.get("127.0.0.1", 3333, "/jsontest").then((HttpClientRequest request) {
          return request.close();

        }).then((HttpClientResponse response) {
          response.transform(new StringDecoder())
          .transform(new LineTransformer())
          .listen((String result) {
            finalString += result;
          },
          onDone: () {
            expect(finalString, equals("{\"test\":\"Yulian\",\"lastTest\":{\"test\":\"Yulian\",\"lastTest\":\"Kuncheff\"}}"));
            expect(response.headers.contentType.mimeType, "application/json");
            completer.complete(true);
          });
        });
      });
      atest();
    });

    test('Simple GET Request 500 Error', () {
      String finalString = "";
      var atest = expectAsync0(() {
        client.get("127.0.0.1", 3333, "/error").then((HttpClientRequest request) {
          return request.close();

        }).then((HttpClientResponse response) {
          response.transform(new StringDecoder())
          .transform(new LineTransformer())
          .listen((String result) {
            finalString += result;
          },
          onDone: () {
            expect(response.statusCode, HttpStatus.INTERNAL_SERVER_ERROR);
            expect(finalString, equals("500 Internal Server Error"));
          });
        });
      });
      atest();
    });
    return completer.future;
  }
}
