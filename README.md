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
v0.0.13
- Bug fix for improper part/import behavior between Formler and Fukiya. Should prevent this from happening to others.

v0.0.12
- Fixing issue with Ints and Doubles during checked mode in prioritizer.

v0.0.11
- Stupid mistake fix.

v0.0.10
- Fixed a missing null check that causes problems if you aren't using static file handler.

v0.0.9
- Extracted form parser into seperate library called Formler. Works much better now, and in turn form parsing is in a better state in Fukiya.

v0.0.8
- Added unit testing.
- Form parser works for everything except Content-Transfer-Encoding: binary. If you want to use it to upload files. Base64 encode them first.

v0.0.7
- Fixing problems with Pub versioning.

v0.0.6
- Added prioritization logic to handle paths similar to each other, but used differenly. Like '/testing' vs '/:someVar' if '/testing' is hit, it should always hit '/testing' and never hit '/:someVar' since it matches also.
- Fixed a few other bugs and languages changes.

v0.0.5
- Changed form parser to a State Machine. Works better, and more efficient. Still some edge cases that I am not covering on purpose.
- Added JSON and File Parsers.
- Fixed some bugs and other stuff.

v0.0.4
- Middleware support.
- Form Parsing. UrlEncoded and MultiPart (MultiPart is very poorly implemented, and hacky, expect bugs.)

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
N/A

Known Bugs
==========
N/A

License
=======
MIT License. See LICENSE file.
