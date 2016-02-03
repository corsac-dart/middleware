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
  /// The [context] parameter is the same object that was passed to
  /// `Pipeline.handle`. Middlewares can use it to access/store shared data.
  Future handle(HttpRequest request, Object context, Next next);
}
