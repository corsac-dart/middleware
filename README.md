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
  Future handle(HttpRequest request, Map context, Next next) {
    // Access response as you usually do.
    request.response.writeln('Hello world');
    return new Future.value();
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
    await pipeline.handle(request);
    request.response.close();
  }
}
```

Please note:

* Since middlewares have full access to `HttpResponse` it is responsibility of
  implementer to make sure response is handled correctly and closed (for
  instance, headers are not being sent after data has been written).

## License

BSD-2
