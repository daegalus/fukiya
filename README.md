Fukiya
======
Simple framework for making dart server applications easier to write. Long way to go, this is very simple.

Example usage:
```dart
void main() {
  Fukiya app = new Fukiya();
  app.get('/', getHandler);
  app.put('/', putHandler);
  app.delete('/', deleteHandler);
  app.post('/', postHandler);
  app.get('/:userid',dynamicHandler);
  app.staticFiles('./static');
  app.listen('127.0.0.1', 3333);
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
