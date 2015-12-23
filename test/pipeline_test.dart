library corsac_middleware.test.pipeline;

import 'dart:async';
import 'dart:io';

import 'package:corsac_middleware/corsac_middleware.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockHttpRequest extends Mock implements HttpRequest {}

void main() {
  group('Pipeline:', () {
    test('it executes one handler', () async {
      Pipeline p = new Pipeline([new SimpleMiddleware()]);

      HandleContext context = await p.handle(new MockHttpRequest());
      expect(context.body, equals('Test'));
    });

    test('it executes two handlers', () async {
      Pipeline p =
          new Pipeline([new ChainingMiddleware(), new SimpleMiddleware()]);

      HandleContext response = await p.handle(new MockHttpRequest());
      expect(response.body, equals('TestChained'));
    });
  });
}

class SimpleMiddleware implements Middleware {
  @override
  Future<HandleContext> handle(
      HttpRequest request, HandleContext context, Next next) {
    return new Future.value(new HandleContext.text('Test'));
  }
}

class ChainingMiddleware implements Middleware {
  @override
  Future<HandleContext> handle(
      HttpRequest request, HandleContext context, Next next) async {
    HandleContext r = await next.handle(request, context);

    return new HandleContext.text(r.body + 'Chained');
  }
}
