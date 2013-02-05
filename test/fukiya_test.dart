import '../lib/fukiya.dart';
import 'dart:io';

void main() {
  new Fukiya()
    ..get('/', getHandler)
    ..put('/', putHandler)
    ..delete('/', deleteHandler)
    ..post('/', postHandler)
    ..get('/:userid', getDynamicHandler)
    ..staticFiles('./test/static')
    ..listen('127.0.0.1', 3333);
}

void getHandler(HttpRequest req, HttpResponse res) {
  res.outputStream.writeString("GET OK", Encoding.UTF_8);
  res.outputStream.close();
}

void putHandler(HttpRequest req, HttpResponse res) {
  res.outputStream.writeString("PUT OK", Encoding.UTF_8);
  res.outputStream.close();
}

void deleteHandler(HttpRequest req, HttpResponse res) {
  res.outputStream.writeString("DELETE OK", Encoding.UTF_8);
  res.outputStream.close();
}

void postHandler(HttpRequest req, HttpResponse res) {
  res.outputStream.writeString("POST OK", Encoding.UTF_8);
  res.outputStream.close();
}

void getDynamicHandler(HttpRequest req, HttpResponse res) {
  res.outputStream.writeString("Dynamic OK ${req.queryParameters['userid']}", Encoding.UTF_8);
  res.outputStream.close();
}
