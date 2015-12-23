library corsac_middleware.test.pipeline;

import 'dart:io';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:corsac_middleware/corsac_middleware.dart';

class MockHttpRequest extends Mock implements HttpRequest {}

void main() {
  group('Pipeline:', () {
    test('it executes one handler', () {
      Pipeline p = new Pipeline([new SimpleMiddleware()]);

      HttpResponseContent content = p.handle(new MockHttpRequest());
      expect(content.body, equals('Test'));
    });

    test('it executes two handlers', () {
      Pipeline p =
          new Pipeline([new ChainingMiddleware(), new SimpleMiddleware()]);

      HttpResponseContent response = p.handle(new MockHttpRequest());
      expect(response.body, equals('TestChained'));
    });
  });
}

class SimpleMiddleware implements Middleware {
  @override
  HttpResponseContent handle(
      HttpRequest request, HttpResponseContent content, Next next) {
    return new HttpResponseContent.text('Test');
  }
}

class ChainingMiddleware implements Middleware {
  @override
  HttpResponseContent handle(
      HttpRequest request, HttpResponseContent content, Next next) {
    HttpResponseContent r = next.handle(request, content);

    return new HttpResponseContent.text(r.body + 'Chained');
  }
}
