part of corsac_middleware;

/// Value object used as an intermediate container for response's data.
///
/// Middleware implementations should use this object instead of actual
/// response available via `HttpRequest` to set following fields:
///
/// * Status code
/// * Content type
/// * Response body itself
///
/// It is allowed for middleware handlers to set any other field on the
/// response object directly.
class HandleContext {
  final int statusCode;
  final ContentType contentType;
  final String body;

  HandleContext(this.statusCode, this.contentType, this.body);

  factory HandleContext.empty({int statusCode: HttpStatus.OK}) =>
      new HandleContext(statusCode, ContentType.TEXT, '');

  factory HandleContext.text(String text, {int statusCode: HttpStatus.OK}) =>
      new HandleContext(statusCode, ContentType.TEXT, text);

  factory HandleContext.json(Object data, {int statusCode: HttpStatus.OK}) =>
      new HandleContext(statusCode, ContentType.JSON, JSON.encode(data));

  factory HandleContext.html(String html, {int statusCode: HttpStatus.OK}) =>
      new HandleContext(statusCode, ContentType.HTML, html);

  /// Applies results of request handling to actual [HttpResponse].
  void apply(HttpResponse response) {
    response
      ..statusCode = statusCode
      ..headers.contentType = contentType
      ..write(body);
  }
}

/// Interface for middleware handlers.
abstract class Middleware {
  Future<HandleContext> handle(
      HttpRequest request, HandleContext context, Next next);
}
