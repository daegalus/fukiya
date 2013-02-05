Fukiya
======
Simple framework for making dart server applications easier to write. Long way to go, this is very simple.

Example usage:
```dart
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
```

Possible TODOs
==============
1. Form handling.

Known Bugs
==========
N/A

License
=======
MIT License. See LICENSE file.
