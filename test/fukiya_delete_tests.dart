library fukiyaDeleteTests;
import 'dart:io';
import 'dart:utf';
import 'dart:isolate';
import 'dart:async';
import 'package:unittest/unittest.dart';

class FukiyaDeleteTests {
  static HttpClient client = new HttpClient();

  static Future<bool> runTests() {
    Completer completer = new Completer();
    group('[DELETE TESTS]', () {
      test('Simple DELETE Request', () {
        String finalString = "";
        var atest = expectAsync0(() {
          client.open("DELETE", "127.0.0.1", 3333, "/").then((HttpClientRequest request) {
            return request.close();

          }).then((HttpClientResponse response) {
            response.transform(new Utf8DecoderTransformer())
            .listen((String result) {
              finalString += result;
            },
            onDone: () {
              expect(finalString, equals("DELETE OK"));
            });
          });
        });
        atest();
      });

      test('Simple DELETE Request with Path', () {
        String finalString = "";
        var atest = expectAsync0(() {
          client.open("DELETE","127.0.0.1", 3333, "/testing").then((HttpClientRequest request) {
            return request.close();

          }).then((HttpClientResponse response) {
            response.transform(new Utf8DecoderTransformer())
            .listen((String result) {
              finalString += result;
            },
            onDone: () {
              expect(finalString, equals("DELETE OK - testing"));
            });
          });
        });
        atest();
        //Timer.run(test);
      });

      test('Complex DELETE Request with Dynamic Path', () {
        String finalString = "";

        var atest = expectAsync0(() {
          client.open("DELETE","127.0.0.1", 3333, "/3727328732").then((HttpClientRequest request) {
            return request.close();

          }).then((HttpClientResponse response) {
            response.transform(new Utf8DecoderTransformer())
            .listen((String result) {
              finalString += result;
            },
            onDone: () {
              expect(finalString, equals("Dynamic DELETE OK 3727328732"));
              completer.complete(true);
            });
          });
        });
        atest();
      });
    });
    return completer.future;
  }
}
