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

      HttpResponseContent content = await p.handle(new MockHttpRequest());
      expect(content.body, equals('Test'));
    });

    test('it executes two handlers', () async {
      Pipeline p =
          new Pipeline([new ChainingMiddleware(), new SimpleMiddleware()]);

      HttpResponseContent response = await p.handle(new MockHttpRequest());
      expect(response.body, equals('TestChained'));
    });
  });
}

class SimpleMiddleware implements Middleware {
  @override
  Future<HttpResponseContent> handle(
      HttpRequest request, HttpResponseContent content, Next next) {
    return new Future.value(new HttpResponseContent.text('Test'));
  }
}

class ChainingMiddleware implements Middleware {
  @override
  Future<HttpResponseContent> handle(
      HttpRequest request, HttpResponseContent content, Next next) async {
    HttpResponseContent r = await next.handle(request, content);

    return new HttpResponseContent.text(r.body + 'Chained');
  }
}
