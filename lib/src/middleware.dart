part of corsac_middleware;

/// Interface for middleware handlers.
abstract class Middleware {
  /// Handles [request].
  ///
  /// If middleware wants to pass handling to the next one in the pipeline it
  /// should call `next.handle()`. In this case implementation needs to make
  /// sure that the `Future` returned from this method completes after the
  /// one returned from the call to `next.handle()`.
  ///
  /// Middlewares can store arbitrary values in the [context] parameter. These
  /// values will be available to all following middlewares in the pipeline.
  Future handle(HttpRequest request, Map context, Next next);
}
