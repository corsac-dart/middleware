library corsac_middleware.test.pipeline;

import 'dart:async';
import 'dart:io';

import 'package:corsac_middleware/corsac_middleware.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockHttpRequest extends Mock implements HttpRequest {}

class MockHttpResponse extends Mock implements HttpResponse {}

void main() {
  group('Pipeline:', () {
    test('it executes one handler', () async {
      Pipeline p = new Pipeline([new SimpleMiddleware()]);
      var request = new MockHttpRequest();
      var response = new MockHttpResponse();
      when(request.response).thenReturn(response);
      await p.handle(request);
      verify(response.writeln('Test'));
    });

    test('it executes two handlers', () async {
      Pipeline p =
          new Pipeline([new ChainingMiddleware(), new SimpleMiddleware()]);

      var request = new MockHttpRequest();
      var response = new MockHttpResponse();
      when(request.response).thenReturn(response);
      await p.handle(request);
      verify(response.writeln('Test'));
      verify(response.writeln('Chained'));
    });
  });
}

class SimpleMiddleware implements Middleware {
  @override
  Future handle(HttpRequest request, Next next) {
    request.response.writeln('Test');
    return new Future.value();
  }
}

class ChainingMiddleware implements Middleware {
  @override
  Future handle(HttpRequest request, Next next) async {
    await next.handle(request);
    request.response.writeln('Chained');
  }
}
