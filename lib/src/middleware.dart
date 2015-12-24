part of corsac_middleware;

/// Interface for middleware handlers.
abstract class Middleware {
  Future handle(HttpRequest request, Next next);
}
