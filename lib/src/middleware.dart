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
class HttpResponseContent {
  final int statusCode;
  final ContentType contentType;
  final String body;

  HttpResponseContent(this.statusCode, this.contentType, this.body);

  factory HttpResponseContent.empty({int statusCode: HttpStatus.OK}) =>
      new HttpResponseContent(statusCode, ContentType.TEXT, '');

  factory HttpResponseContent.text(String text,
          {int statusCode: HttpStatus.OK}) =>
      new HttpResponseContent(statusCode, ContentType.TEXT, text);

  factory HttpResponseContent.json(Object data,
          {int statusCode: HttpStatus.OK}) =>
      new HttpResponseContent(statusCode, ContentType.JSON, JSON.encode(data));

  factory HttpResponseContent.html(String html,
          {int statusCode: HttpStatus.OK}) =>
      new HttpResponseContent(statusCode, ContentType.HTML, html);
}

/// Interface for middleware handlers.
abstract class Middleware {
  HttpResponseContent handle(
      HttpRequest request, HttpResponseContent content, Next next);
}
