# Corsac HTTP middleware and pipeline for HttpServer

Dart's built-in HttpServer is pretty awesome, so why not have middleware
framework which can work with `HttpRequest` and `HttpResponse` from `dart:io`?

## Status

This library is a work-in-progress so breaking changes may occur without notice.

## Installation

Via Git dependency in your `pubspec.yaml`:

```yaml
dependencies:
  corsac_middleware:
    git: https://github.com/corsac-dart/middleware.git
```

Import:

```dart
import 'package:corsac_middleware/corsac_middleware.dart'
```

Pub package will be added as soon as API is stable enough.

## Usage

Define your middleware by implementing `Middleware` interface:

```dart
// file:hello_world.dart
import 'dart:async';
import 'package:corsac_middleware/corsac_middleware.dart';

class HelloWorldMiddleware implements Middleware {
  @override
  Future<HandleContext> handle(
    HttpRequest request, HandleContext context, Next next) {
    return new Future.value(new HandleContext.text('Hello world'));
  }
}
```

Create your pipeline and use in typical HttpServer application:

```dart
// file:main.dart
import 'dart:io';
import 'dart:async';
import 'package:corsac_middleware/corsac_middleware.dart';
import 'hello_world.dart';

Future main() async {
  final server = await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 8080);
  final pipeline = new Pipeline([new HelloWorldMiddleware()]);
  await for (HttpRequest request in server) {
    HandleContext result = await pipeline.handle(request);
    result.apply(request.response);
    request.response.close();
  }
}
```
