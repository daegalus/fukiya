import '../lib/fukiya.dart';
import 'dart:io';

void main() {
  new Fukiya()
    ..get('/', getHandler)
    ..put('/', putHandler)
    ..delete('/', deleteHandler)
    ..post('/', postHandler)
    ..get('/testing', (FukiyaContext context) {
      context.send("This is testing.");
    })
    ..get('/:userid', getDynamicHandler)
    ..staticFiles('./test/static')
    ..use(new FukiyaFormParser())
    ..use(new FukiyaJsonParser())
    ..listen('127.0.0.1', 3333);
}

void getHandler(FukiyaContext context) {
  context.send("GET OK");
}

void putHandler(FukiyaContext context) {
  context.send("PUT OK");
}

void deleteHandler(FukiyaContext context) {
  context.send("DELETE OK");
}

void postHandler(FukiyaContext context) {
  print(context.parsedBody);
  context.send("POST OK");
}

void getDynamicHandler(FukiyaContext context) {
  context.send("Dynamic OK ${context.params['userid']}");
}
