v0.1.11
- Updated imports to handle change of JSON being removed from SDK libraries and put in PUB.

v0.1.10
- Updated for the latest changes in Dart. Thanks to [Adam Singer](https://github.com/financeCoding) for the help.

v0.1.9
- Return 500 on uncaught exception in Zone. If the response isn't already closed, it will set the status to 500 and close it.

v0.1.8
- All handlers are now wrapped in runZoned, so no matter what happens in user created handlers, the server should theoretically never crash due to an error in the handler.

v0.1.7
- Fixed bug where if there is an exception in the handler, it will crash the server. It now should not do that.
- Added a new jsonResponse function to the context. When passed a JSONifiable object/map it will JSONify it and send it with appropriate contenttype headers.

v0.1.6
- Changed static file handling to use the wonderful [library](https://github.com/DanieleSalatti/static-file-handler) created by Daniele Salatti.
- Added functions to be able to add MimeTypes to the StaticFileHandler library from Fukiya.
- Added additional test to make sure static file handling overrode any other paths.

v0.1.5
- Fixing breakage in path.pathSegments. Reverted back to path.split('/')

v0.1.4
- Fixing immutable map problem with queryParameters.

v0.1.3
- Fixing query parameter related stuff.

v0.1.2
- Fixing Crypto package change.
- HttpRequest QueryParamters change.

v0.1.1
- Merged typed-data name fix
- Uses new version of Formler

v0.1.0
- Updated for M4 changes.
- I think this is 0.1 ready. So bumping to 0.1.
- Add a bunch of Comments to the library, preparing for DartDoc generation and better documentation.

v0.0.14
- Added a redirect() function to faciliate easier 302 redirects.
- Replaced a few hardcoded HTTP Statuses to use the HttpStatus constants/enum.

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
