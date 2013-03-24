library fukiyPutTests;
import 'dart:io';
import 'dart:isolate';
import 'dart:async';
import 'package:unittest/unittest.dart';

class FukiyaPutTests {
  static HttpClient client = new HttpClient();

  static Future<bool> runTests() {
    Completer completer = new Completer();
    group('[PUT TESTS]', () {
      test('Simple PUT Request', () {
        String finalString = '';
        var atest = expectAsync0(() {
          client.open('PUT', '127.0.0.1', 3333, '/').then((HttpClientRequest request) {
            request.headers.contentType = new ContentType('application', 'json', charset: 'utf-8');
            request.contentLength = '{ "username": "daegalus", "password": "somePass" }'.length;
            request.write('{ "username": "daegalus", "password": "somePass" }');
            return request.close();

          }).then((HttpClientResponse response) {
            response.transform(new StringDecoder())
            .transform(new LineTransformer())
            .listen((String result) {
              finalString += result;
            },
            onDone: () {
              expect(finalString, equals('PUT OK daegalus - somePass'));
            });
          });
        });
        atest();
      });

      test('Simple PUT Request with Put Data URLEncoded', () {
        String finalString = '';
        var atest = expectAsync0(() {
          client.open('PUT', '127.0.0.1', 3333, '/').then((HttpClientRequest request) {
            request.headers.contentType = new ContentType('application', 'x-www-form-urlencoded', charset: 'utf-8');
            request.contentLength = 'username=daegalus&password=somePass'.length;
            request.write('username=daegalus&password=somePass');
            return request.close();

          }).then((HttpClientResponse response) {
            response.transform(new StringDecoder())
            .transform(new LineTransformer())
            .listen((String result) {
              finalString += result;
            },
            onDone: () {
              expect(finalString, equals('PUT OK daegalus - somePass'));
            });
          });
        });
        atest();
      });

      test('Complex PUT Request with Dynamic Path', () {
        String finalString = '';

        var atest = expectAsync0(() {
          client.open('PUT', '127.0.0.1', 3333, '/3727328732').then((HttpClientRequest request) {
            request.headers.contentType = new ContentType('application', 'json', charset: 'utf-8');
            request.contentLength = '{ "username": "daegalus", "password": "somePass" }'.length;
            request.write('{ "username": "daegalus", "password": "somePass" }');
            return request.close();

          }).then((HttpClientResponse response) {
            response.transform(new StringDecoder())
            .transform(new LineTransformer())
            .listen((String result) {
              finalString += result;
            },
            onDone: () {
              expect(finalString, equals('Dynamic PUT OK 3727328732 - daegalus'));
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
