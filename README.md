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
  app.staticFiles('./static');
  app.listen('127.0.0.1', 3333);
}
```

The Paths are currently simple strings, it doesn't support regex, or complex pathing yet.

Possible TODOs
==============
1. Wrap HttpRequest and HttpResponse to create automated paramter, query, and post handlers for easy access.
2. Regex Matching to URLs so that you can have custom identifiers for pathing. Ex. "/some/path/:userid"
3. Form handling.

Known Bugs
==========
Static Files doesn't work, and just returns 404.

License
=======
MIT License. See LICENSE file.