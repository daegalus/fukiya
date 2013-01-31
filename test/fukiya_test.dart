import '../lib/fukiya.dart';
import 'dart:io';

void main() {
  Fukiya app = new Fukiya();
  app.get('/', getHandler);
  app.put('/', putHandler);
  app.delete('/', deleteHandler);
  app.post('/', postHandler);
  app.staticFiles('./static');
  app.listen('127.0.0.1', 3333);
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
