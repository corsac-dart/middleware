part of corsac_middleware;

/// Represents pipeline execution queue.
///
/// Each time [Pipeline] handling is executed we create queue of middleware handlers
/// and store it in the instance of this class which is passed from one handler to
/// another.
class Next {
  Queue<Middleware> _handlers;
  Next(this._handlers);

  Future handle(HttpRequest request) {
    if (this._handlers.isEmpty) {
      return new Future.value();
    } else {
      Middleware handler = this._handlers.removeFirst();
      return handler.handle(request, this);
    }
  }
}

/// Represents a pipeline of middleware handlers.
class Pipeline {
  List<Middleware> handlers;

  /// Pipeline constructor.
  Pipeline(this.handlers);

  /// Executes middleware pipeline.
  Future handle(HttpRequest request) {
    Queue queue = new Queue.from(this.handlers);
    Next next = new Next(queue);

    return next.handle(request);
  }
}
