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
      Pipeline p = new Pipeline([new SimpleMiddleware()].toSet());
      var request = new MockHttpRequest();
      var response = new MockHttpResponse();
      when(request.response).thenReturn(response);
      await p.handle(request, null);
      verify(response.writeln('Test'));
    });

    test('it executes two handlers', () async {
      Pipeline p = new Pipeline(
          [new ChainingMiddleware(), new SimpleMiddleware()].toSet());

      var request = new MockHttpRequest();
      var response = new MockHttpResponse();
      when(request.response).thenReturn(response);
      await p.handle(request, new Map());
      verify(response.writeln('Test'));
      verify(response.writeln('Chained'));
    });

    test('it has shared context', () async {
      Pipeline p = new Pipeline(
          [new ChainingMiddleware(), new ContextAccessingMiddleware()].toSet());

      var request = new MockHttpRequest();
      var response = new MockHttpResponse();
      when(request.response).thenReturn(response);
      await p.handle(request, new Map());
      verify(response.writeln('Version:3'));
      verify(response.writeln('Chained'));
    });

    test('it executes beforeHandlers first', () async {
      var p = new Pipeline([new SimpleMiddleware()].toSet());
      p.beforeHandlers.add(new BeforeMiddleware());

      var request = new MockHttpRequest();
      var response = new MockHttpResponse();
      when(request.response).thenReturn(response);
      await p.handle(request, new Map());
      verifyInOrder([response.writeln('Before'), response.writeln('Test'),]);
    });
  });
}

class SimpleMiddleware implements Middleware {
  @override
  Future handle(HttpRequest request, Map context, Next next) {
    request.response.writeln('Test');
    return new Future.value();
  }
}

class ChainingMiddleware implements Middleware {
  @override
  Future handle(HttpRequest request, Map context, Next next) async {
    context[#version] = 3;
    await next.handle(request, context);
    request.response.writeln('Chained');
  }
}

class ContextAccessingMiddleware implements Middleware {
  @override
  Future handle(HttpRequest request, Map context, Next next) {
    var v = context[#version];
    request.response.writeln('Version:${v}');
    return new Future.value();
  }
}

class BeforeMiddleware implements Middleware {
  @override
  Future handle(HttpRequest request, Object context, Next next) {
    request.response.writeln('Before');
    return next.handle(request, context);
  }
}
