[![Build Status](https://drone.io/github.com/Daegalus/fukiya/status.png)](https://drone.io/github.com/Daegalus/fukiya/latest)

Fukiya
======
Simple framework for making dart server applications easier to write. Long way to go, this is very simple.
Proper documentation will be written when the library matures a bit more.

For a practicle example, look at fukiya_test.dart in the test directory.

Example usage:
```dart
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
```

Changes
=======
See CHANGELOG file.

License
=======
MIT License. See LICENSE file.
