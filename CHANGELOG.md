## 0.1.0

- Initial version of Dart express with basic functionality for routing and middleware

## 0.1.1

- Add dependencies for Jael (will be breaking this out to a separate package later)

## 0.2.0

- Add `path_to_regexp` package to improve route matching.
- Add support for route parameters using `path_to_regexp` package.
- Improve README to include additional documentation
- Add `res.end()` and `res.location()` methods to Response class.

## 0.2.1

- Clean up Request & Response classes
- Export HTTPStatus class from dart-express directly

## 0.2.2

- Fix issue with relative paths for views
- Add app.set('views', './path');
- Add app.set('view engine', './path')

## 0.2.3

- Throw error when providing an invalid setting key

## 0.2.4

- Add View Engine tests to ensure view rendering is working as expected
- Add Markdown View Engine to parse and display Markdown files
- Add documentation for public API and clean up interfaces

## 0.3.0

- Add ability to listen on address other than loopback address (Thanks @jeffmikels)

## 0.4.0

- Add all files as part of `dart_express` library
- Change visibility of certain classes
- Defer loading of View template libraries

## 0.5.0

- Add CORS middleware

## 0.5.1

- Add basic Logger middleware
- Fix middleware not loading issue

## 0.5.2

- Fix Body parser middleware
