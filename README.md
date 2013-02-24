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
    ..get('/:userid', getDynamicHandler)
    ..staticFiles('./test/static')
    ..listen('127.0.0.1', 3333);
}
```

Changes
=======
v0.0.3
- Updated for M3. Current changes made it MUCH easier to wrap things and route.
- Added FukiyaContext that can be used to store Middleware data. More on that in future versions.
- This release breaks compatibility with anything before M3.

v0.0.2
- Pattern support in URLs.
- Fixed Static File Handler.

v0.0.1
- Initial Release, basic routing worked. Static files broken.

TODOs
=====
1. Form handling.
2. JSON Handling.
3. Middleware Support

Known Bugs
==========
N/A

License
=======
MIT License. See LICENSE file.
