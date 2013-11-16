library fukiyaOptionsTests;
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:unittest/unittest.dart';

class FukiyaOptionsTests {
  static HttpClient client = new HttpClient();

  static Future<bool> runTests() {
    Completer completer = new Completer();
    group('[OPTIONS TESTS]', () {
      test('Simple OPTIONS Request', () {
        String finalString = "";
        var atest = expectAsync0(() {
          client.open("OPTIONS", "127.0.0.1", 3333, "/").then((HttpClientRequest request) {
            return request.close();

          }).then((HttpClientResponse response) {
            response.transform(new Utf8Decoder())
            .transform(new LineSplitter())
            .listen((String result) {
              finalString += result;
            },
            onDone: () {
              expect(finalString, equals("OPTIONS OK"));
            });
          });
        });
        atest();
      });

      test('Simple OPTIONS Request with Path', () {
        String finalString = "";
        var atest = expectAsync0(() {
          client.open("OPTIONS","127.0.0.1", 3333, "/testing").then((HttpClientRequest request) {
            return request.close();

          }).then((HttpClientResponse response) {
            response.transform(new Utf8Decoder())
            .transform(new LineSplitter())
            .listen((String result) {
              finalString += result;
            },
            onDone: () {
              expect(finalString, equals("OPTIONS OK - testing"));
            });
          });
        });
        atest();
      });

      test('Complex OPTIONS Request with Dynamic Path', () {
        String finalString = "";

        var atest = expectAsync0(() {
          client.open("OPTIONS","127.0.0.1", 3333, "/3727328732").then((HttpClientRequest request) {
            return request.close();

          }).then((HttpClientResponse response) {
            response.transform(new Utf8Decoder())
            .transform(new LineSplitter())
            .listen((String result) {
              finalString += result;
            },
            onDone: () {
              expect(finalString, equals("Dynamic OPTIONS OK 3727328732"));
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
