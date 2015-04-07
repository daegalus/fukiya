[![Build Status](https://drone.io/github.com/Daegalus/fukiya/status.png)](https://drone.io/github.com/Daegalus/fukiya/latest)

Fukiya
======

[![Join the chat at https://gitter.im/Daegalus/fukiya](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/Daegalus/fukiya?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
Simple framework for making dart server applications easier to write. Long way to go, this is very simple.
Proper documentation will be written when the library matures a bit more.

For a practical example, look at fukiya_*_test.dart tests in the test directory.

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
